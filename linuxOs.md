```bash
#################################### Working with directories

   man -> manual

man gives you information about whatever comman you are trying to run
-----------------------------------------------------------

   pwd -> print name of current/working directory
-----------------------------------------------------------

   cd -> change directory	{has no manual}

relative path -> an assumed path ie 
absolute path -> full location to a file or directory ie 
cd takes you back to home directory no matter where you are
cd - toggles between paths
-----------------------------------------------------------


   ls -> list directory contents

linux uses a period(.) for hidden files

   /mnt/c/users/admin/desktop$ ls Testcp/
   /mnt/c/users/admin$ ls desktop/test
   /mnt/c/users$ ls admin/desktop/test

   ls -a => shows all files whether hidden or not
   ls -l => shows files in long list format

running more than one flag -> ls -la

   ls -h => shows content in human readble format
   ls -lah => shows size of files and folders in human readable format {the sizeof the files}
-----------------------------------------------------------


   mkdir -> make directories

If you try to create the same directory in the same location; 
--- mkdir: cannot create directory ‘Test’: File exists

mkdir Test
   cd Test > mkdir Test2

directoy tree
   mkdir -p Linux/Ubuntu/Benjn
-----------------------------------------------------------

   rmdir -> remove empty directories

deleting a directory with contents
   rmdir -p linux/ubuntu/benjn
-----------------------------------------------------------




#################################### Working with directories Working with files

- files are not case sensitive unlike in windows
- directories are considered as files
- linuxOs doesn't determine a file type by a file extention

   file —> determine file type

   file 'Mosa money pot.png'
Mosa money pot.png: PNG image data, 716 x 920, 8-bit/color RGBA, non-interlaced

   file Mosa.ai
Mosa.ai: PDF document, version 1.6, 1 pages

   file mosa.jpg
mosa.jpg: JPEG image data, JFIF standard 1.02, resolution (DPI), density 300x300, segment length 16, baseline, precision 8, 1181x1181, components 3
-----------------------------------------------------------

   touch -> create empty files

   touch file.txt -> creates a new txt file called file1

creating multiple files
   touch file2.txt file3.txt
-----------------------------------------------------------

   rm -> remove files or directories

   rm file1.txt

   rm -i => interactive mode, prompt before every removal
   rm -i file2.txt file3.txt

  rm -r => remove directories and their contents recursively
  rm -f => ignore nonexistent files and arguments, never prompt

removing a directory with rm
  rm -rf Test
-----------------------------------------------------------

  cp -> copy files and directories

copying file in the same directory
   cp file1.txt file1cp.txt

copying file to a specific directory
   cp file1.txt /c/users/admin/desktop/		*didn't work

copying a directory into the same directory
   cp -r Test Testcp
----------------------------------------------------------

   mv -> move (rename) files

using move command to rename files
   mv file1.txt file2.txt

moving file to another directory using absolute path
moving and renaming at the same time

  /mnt/c/Users/Admin/Desktop$ mv file2.txt test/file3.txt
  ls -l test/		{to display}

renaming folder with mv
  mv testcp testpc
-----------------------------------------------------------




#################################### Working with file content

   head -> output the first part of files

Pulls the first 10 lines
   /mnt/c/Users/Admin/Desktop/javascript$ head freeCodeCamp_javascript.txt
To test whether js runs on your machine, create html file --
<script>
    console.log("Hello world");
</script>

In the browser, press Ctrl + Shift + I or More tools > Developer tools


------------------------------------------- Data types and Variables

   head -5 freeCodeCamp_javascript.txt => To shows the first 5 lines of a file

To test whether js runs on your machine, create html file --
<script>
    console.log("Hello world");
</script>
-----------------------------------------------------------

   tail -> output the last part of files (10 lines by default)

   tail freeCodeCamp_javascript.txt
------------------------------------------- Import a default export

    // default export don't {}
    import subtract from "math_functions"

    subtract(7, 4);

------------------------------------------- END
-------------------------------------------
-------------------------------------------
-----------------------------------------------------------

   cat -> concatenate files and print on the standard output
prints thw whole file content

  cat new.txt
-----------------------------------------------------------

   echo -> display a line of text

Also creates a new file and adds content to it
   /mnt/c/Users/Admin/Desktop$ echo A file was created with echo command and this text was added simultaneously > new.txt
-----------------------------------------------------------

   echo The > text1.txt
   echo big > text2.txt
   echo apple > text3.txt

   cat text1.txt text2.txt text3.txt
The
big
apple

To ouput the content in a file instead of the terminal
   cat test1.txt test2.txt test3.txt > all.txt

To create a file add content to it
   cat > file1.txt
 _ then type some text
after press Ctrl + D to save

copying a file and naming it something else
   cat file1.txt > file2.txt
-----------------------------------------------------------

   more -> file perusal filter for crt viewing
shows content of a file page by page
-----------------------------------------------------------

   less -> opposite of more
-----------------------------------------------------------




/////////////////// Linux File Structure

adduser@DESKTOP-UQ666I0:~$ cd
adduser@DESKTOP-UQ666I0:~$ cd /
adduser@DESKTOP-UQ666I0:/$ pwd
/
adduser@DESKTOP-UQ666I0:/$ ls -l




/////////////////// System Information

   uptime - Tell how long the system has been running.
   free - Display amount of free and used memory in the system
   ps - report a snapshot of the current processes
   df - report file system disk space usage




####################################  Networking




#################################### Pipes


```