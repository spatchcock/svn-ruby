SVN-ruby
========

This is a lightweight wrapper written in Ruby for the Linux command line SVN interface. It allows basic interaction with an SVN repository, including adding, renaming, deleting, committing, diffing and checking the status of files.

Usage instructions
------------------

SVN authentication credentials must be initialized as follows:

	SVN.username = "a_username"
	SVN.password = "a_password"

File management can then be performed:

	File.open("new_file.txt", 'w') { |file| file.write "This is a new file" }

	SVN.status                               => [["?", "new_file.txt"]]

	SVN.add "new_file.txt"                   => "A         new_file.txt\n"

	SVN.commit "adding new file"             => "12345 // new revision number



