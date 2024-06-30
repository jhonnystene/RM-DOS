// rmfs-insert
// Tool to insert files into RMFS images
// Copyright (c) 2024 Johnny Stene. Some Rights Reserved.

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

int main(int argc, char** argv) {
	printf("rmfs-insert version 1.0.0\n");
	if(argc != 4) {
		printf("Usage: %s <image file> <target file> <target filename>\n", argv[0]);
		return -1;
	}

	printf("Loading image file...\n");
	FILE *imgptr;
	imgptr = fopen(argv[1], "rb");
	if(imgptr == NULL) {
		printf("Failed to open file %s.\n", argv[1]);
		return -2;
	}

	fseek(imgptr, 0, SEEK_END);
	long image_size = ftell(imgptr);
	fseek(imgptr, 0, SEEK_SET);

	uint8_t* image_buffer = (uint8_t*) malloc(image_size);
	if(!image_buffer) {
		printf("Memory allocation failed\n");
		fclose(imgptr);
		return -3;
	}

	size_t bytes_read = fread(image_buffer, sizeof(uint8_t), image_size, imgptr);
	if(bytes_read != image_size || image_size == 0) {
		printf("Failed to read image file.\n");
		free(image_buffer);
		fclose(imgptr);
		return -4;
	}
	
	fclose(imgptr);

	// Validate image
	if(image_buffer[30] == 0x31 && image_buffer[31] == 0xDA) {
		printf("Found valid magic number in image file.\n");
	} else {
		printf("%s is not a valid image file.\n", argv[1]);
		return -5;
	}

	printf("Volume label is %s\n", &image_buffer[16]);

	printf("Loading target file...\n");

	FILE *fptr;
	fptr = fopen(argv[2], "r");
	if(fptr == NULL) {
		printf("Failed to open file %s.\n", argv[2]);
		return -2;
	}

	fseek(fptr, 0, SEEK_END);
	long file_size = ftell(fptr);
	fseek(fptr, 0, SEEK_SET);

	uint8_t* file_buffer = (uint8_t*) malloc(file_size);
	if(!file_buffer) {
		printf("Memory allocation failed\n");
		fclose(imgptr);
		fclose(fptr);
		return -3;
	}

	bytes_read = fread(file_buffer, sizeof(uint8_t), file_size, fptr);
	if(bytes_read != file_size || file_size == 0) {
		printf("Failed to read image file.\n");
		free(image_buffer);
		free(file_buffer);
		fclose(imgptr);
		fclose(fptr);
		return -4;
	}
	
	fclose(fptr);
	
	if(strlen(argv[3]) > 12) {
		printf("Max filename length is 12 bytes, including terminator\n");
		return -5;
	}
	
	int block_count = (file_size + (511)) / 512;
	printf("File will take up %d blocks on disk.\n", block_count);
	
	uint8_t* file_table = &image_buffer[512];
	uint16_t* allocation_table = (uint16_t*) &image_buffer[1024];
	
	printf("Creating File Table entry...\n");
	for(int ft_index = 0; ft_index < 32; ft_index++) {
		if(file_table[ft_index * 16] == 0x00) { // Empty file
			printf("Found empty File Table entry %d\n", ft_index);
			strcpy(&file_table[ft_index * 16], argv[3]);
			uint16_t* first_block_location = (uint16_t*) &file_table[(ft_index * 16) + 12];
			
			printf("Populating Allocation Table...\n");
			int previous_block_index;
			int found_blocks;
			for(int block_number = 0; block_number < block_count; block_number++) {
				for(int block_index = 0; block_index < 512; block_index++) {
					if(allocation_table[block_index] == 0x0000 && block_index != previous_block_index) {
						//printf("Found empty block %d\n", block_index);
						
						if(block_number == 0) {
							first_block_location[0] = block_index;
						} else {
							allocation_table[previous_block_index] = block_index;
						}
						
						if(block_number == block_count - 1) {
							allocation_table[block_index] = 0xFFFF;
						}
						
						int targetbyte = (512 * block_index);
						//printf("Copying next block to position %d...\n", targetbyte);
						uint8_t* block = &file_buffer[512 * found_blocks];
						uint8_t* target = &image_buffer[targetbyte];
						memcpy(target, block, 512);
						
						previous_block_index = block_index;
						found_blocks++;
						
						break;
					}
				}
			}
			
			if(found_blocks != block_count) {
				printf("Could not find enough free blocks (need %d, found %d)\n", block_count, found_blocks);
				return -6;
			} else {
				printf("Entire file fits. Committing changes.\n");
			}
			
			printf("Loading image file...\n");
			imgptr = fopen(argv[1], "wb");
			if(imgptr == NULL) {
				printf("Failed to open file %s.\n", argv[1]);
				return -2;
			}
			
			fwrite(image_buffer, sizeof(uint8_t), image_size, imgptr);
			fclose(imgptr);
			
			return 0;
		}
	}
	
	printf("Could not find empty file table entry\n");
	return -6;
}
