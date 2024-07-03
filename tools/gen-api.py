#/usr/bin/env python3
# RM-DOS API Include File generator

import sys

print("Generating RM-DOS API file...")
try:
	# Call vector list stored in kernel.asm
	with open("./src/kernel/kernel.asm") as kernel_file:
		kernel_text = kernel_file.read()
		
		try:
			# We will overwrite the files in the SDK folder as this needs to always be up to date
			api_file = open("./sdk/RMDOS.asm", "w")
			api_docs = open("./sdk/docs/API.txt", "w")
			
			# Write docs header
			api_docs.write("RM-DOS API Functions\n")
			
			# Make sure apps always target the write addresses
			api_file.write("BITS 16\n")
			api_file.write("ORG 32768\n")
			api_file.write("jmp progmain\n")
			current_location = 0
			
			# Go through every line in the kernel
			for line in kernel_text.split("\n"):
				# Call vectors end here
				if(line.startswith("kernel_bootstrap")):
					break;
				
				# Make sure we are actually looking at a call vector
				line_text = line.strip()
				if(line_text.startswith("jmp ")):
					# Save the name of the call vector in the API file along with its address
					name = line_text[4:].split("\t")[0]
					api_file.write(name + " equ " + format(current_location, '04X') + "h\n")
					current_location += 3
					# Save the function and its description in the docs
					api_docs.write("=== FUNCTION ===\n")
					api_docs.write("NAME: " + line_text[4:].split("\t")[0] + "\n")
					api_docs.write("DESCRIPTION: " + line_text.split("; ")[1] + "\n")
					api_docs.write("\n")
				# Or are we looking at a kernel message?
				elif(line_text.startswith("kernel_msg")):
					api_file.write(line_text + "\n")
					api_docs.write("=== KERNEL MESSAGE ===\n")
					api_docs.write("NAME: " + line_text.split("\t")[0] + "\n")
					api_docs.write("TEXT: \"" + line_text.split("\"")[1] + "\"\n")
					api_docs.write("\n")
		except:
			print("Error: Failed to load sdk/RMDOS.asm")
			sys.exit(-1);	
except:
		print("Error: Failed to load src/kernel/kernel.asm")
		sys.exit(-1)
