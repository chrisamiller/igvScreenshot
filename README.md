# igvScreenshot
Create static screenshots of genomic regions using IGV.

##Short version
1. Create a single directory that contains, for each sample, an IGV XML file and a bed file of genomic sites that you wish to review.
2. From that directory, create batch files with
       bash igvCreateBatchFiles.sh
3. then, to create screenshots for each sample on an LSF cluster, run

       for i in *.igv;do 
           bsub -oo err.log -q long -M 12000000 -R 'select[mem>12000] rusage[mem=12000]' "bash ~cmiller/oneoffs/igvCreateSnapshots.sh $i"; 
       done

Your screenshots will be stored in SAMPLENAME_snaps and look something like the thumbnail attached below.  I like the geeqie program for flipping through them rapidly. You can install it on Ubuntu with 'sudo apt-get install geeqie'.

![IGVscreenshot](https://i.imgur.com/4nelXlc.png)

 
##Long version:
The scripts have some specific requirements. The first step currently expects a single folder with an IGV XML and bed file for each sample, with exactly matching names. For example:

       H_KA-1234.xml
       H_KA-1234.bed
       H_KA-2345.xml
       H_KA-2345.bed

You can create IGV XML files by mannually loading the bams and bed files and then saving your session from the GUI, or you can automate it, using something like (this script)[https://github.com/genome/genome/blob/master/lib/perl/Genome/Model/Tools/Analysis/DumpIgvXmlMulti.pm].

From within your directory of files, run:

     bash ~cmiller/oneoffs/igvCreateBatchFiles.sh
This creates an igv batch file that IGV knows how to run. 

If you only had one sample, you could just load IGV, go to Tools > Run Batch File, and let IGV run on your workstation. Since we probably want to generate screenshots for lots of sites (and because IGV is resource-hungry), we probably want to run these by submitting jobs on a cluster (in this case, I'm assuming you use an LSF cluster of Ubuntu boxes).

This is complicated, because IGV demands that it actually pump the data to a display server, whether or not anyone is actually looking at it. The 'igvCreateSnapshots' script launches a non-displayed display server using Xvfb, sets the appropriate env variables, then runs IGV in batch mode. The script also takes care of finding an open display port, since there could be conflicts from multiple processes on the same blade.  Since we want to launch one job for each XML file:

    for i in *.igv;do bsub -oo err.log -q long -M 12000000 -R 'select[mem>12000] rusage[mem=12000]' "bash ~cmiller/oneoffs/igvCreateSnapshots.sh"
If you need to see more or less data, you can alter the 'maxPanelHeight' parameter in the igvCreateBatchFiles script.

There's also an issue where the first screenshot or two sometimes look condensed. I'm not sure if this is an IGV bug or what, but I'm currently looking for workarounds. (maybe plot a few random locations first, then remove these files?)