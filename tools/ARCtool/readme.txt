Command line tool for unpacking and repacking ARC files. Version 0.9.428

Features:
- Unpack and repack
- Using text file as reference for file order
- Real extension support for RE5 and Dragon's Dogma (with incomplete lists for other games)
- Support for no compression, dynamic compression or always compression when repacking archives
- Automatic conversion of TEX to DDS/TGA, and DDS/TGA to TEX (more information about it further below)
- Automatic conversion between GMD and TXT (more information below)
- Automatic renaming of stages in RE5 and RE6 to other stage nums. (more information below)
- Supports xbox, ps3 and pc ARC formats.

Currently supported games:
- RE HD (-REHD)
- RE5 (-RE5)
- RE6 (-RE6)
- RE: Revelations (-REV)
- RE: Revelations 2 (-REV2)
- Dragon's Dogma (-DD)
- Devil May Cry 4 (-DMC4) (only PC version is supported)
- Devil May Cry 4: Special Edition (-DMC4SE) (only PC version is supported)
- Ultimate vs Capcom 3 (-UMVC3)

Example usage in command prompt to extract and repack:
xbox-re6 s0305.arc
xbox-re6 s0305
pc-re5 fig01.arc
pc-re5 fig01

Example usage in Windows Explorer:
Just drag and drop files/directories onto the proper .bat files. Ie, drag and drop s0305.arc to pc-re6.bat to extract it. And drag and drop s0305 to pc-re6.bat to repack it.

Various notes:
- I've supplied batch files for easier usage. They are correctly configured for the respective games, however "-tex" and "-gmd" arguments must be added manually.
- Other MT Framework games (Dead Rising, Lost Planet 1/2 and Marvel vs Capcom 3) might be supported too, but they haven't been tested.
- Thanks goes to rick and aluigi as I used specifications about the ARC format from them to make this tool.
- Maximum size limit of files within arc files is around 100mb.
- I consider the tool to be experimental at the moment, so there might be bugs.
- For MT Framework v2 games (ie, Dragon's Dogma, Revelations and Resident Evil 6), the game requires certain files to be in order in the arc file. To accomplish that, my tool creates a text file with file order from extracted arc it uses when repacking. Any files which is not listed in that text file will NOT be added to the archive.

Info about TEX conversion:
- Use the "-tex" argument to activate automatic conversion during repacking or extraction.
- This can also be used without having to interfact with arc files. Just run the program with only "-tex" and the type of tex file (ie, "-texRE6") and then write the location of a TGA, DDS or TEXfile. This works with xbox and pc files. There are also batch files which simplifies this process. Remember the TEX file needs to be present as some data is read from it.
- This does not work with all TEX files. It should safely ignore unsupported TEX files.
- You'll need to specify TEX type. Either "-texRE5" or "texRE6". They are already defined in the batch files.
- Texture type needs to be the same when converting back to TEX.
- When converting to TEX, it'll update every TEX file in the archive AND extracted version of the archive. Make sure to keep backups.
- During repacking, any file with the extension DDS, TGA or TXT will never be directly added to the archive.
- It reads from the TXT file with same name for some properties.
- For xbox, it converts from TGA files. For pc, it converts from DDS files. This can't be changed.
- You can add "-renameconvtex" when extracing arc files to make sure converted tex files gets a unique name. Handy for controlling which DDS/TGA files end up being converted back to TEX.
- Xbox: When converting to TEX files, you'll need to use the same resolution and mipmap count when converting from TGA to TEX.
- Xbox: There is an amount of lossyness during conversion. I'm not completely sure of the cause, and I'm not sure if it happens when converting to TGA or to TEX. Either way, make sure to do only one conversion per file. If there's textures you're not gonna edit at all, just delete the corresponding TGA and/or TXT files to ensure they are not converted.

Info about GMD conversion:
- Use -"gmd" argument to activate automating conversion during repacking or extraction.
- This only works with GMD files from Dragon's Dogma.
- When converting to TEX, it'll update every TEX file in the archive AND extracted version of the archive. Make sure to keep backups.
- During repacking, any file with the extension TXT will never be directly added to the archive.

Info about RE5/RE6 stage renaming.
- Use "-tostage #" where # is the num of the new stage you want the stage to be. You use this command line argument while extracting an arc.
- This is for experienced modders only as there's other necessary steps to get this fully working. For both RE5 and RE6 you also need to update player's spawn positions in the stage's stp file. For RE6 you need to mess around with shader packages to get the stage to render properly.