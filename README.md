
# IGV

## Version

 | | |
---|---
__Program version__|2.8.4
__Databiology Application Version__|2.0.0

## Deploying

If you want to deploy the latest version of this app, this is the pull you should do:

     docker pull hub.databiology.net/dbio/igv:2.0.0

If you want to deploy a previous version, the pull should be:

     docker pull hub.databiology.net/dbio/igv:{VERSION}

Just replace {VERSION} with the Version you're interested in. For full deployment instructions, please see [our in-depth guide on application deployment](https://docs.databiology.net/tiki-index.php?page=Operations%3ADeploying+an+Application).

## Application Changelog

 | | |
---|---
Version|Release Notes
2.0.0|Update IGV version from 2.6.2 to 2.8.4, base image, namespace migration
1.3.5|Add file check for no_output.sh
1.3.4|Add license
1.3.3|Adding igvtools and indexing input BAM files
1.3.2|New Wallpaper
1.3.1|Use Desktop 1.4.0, Generate file if no output was created: now a workunit won’t be wrongly marked as ''failed'' if the user didn’t save or generate any other output before terminating it.
1.2.0|Update to CIAO5
1.1.4|Home directory update
1.0.7|Initial version

## Description

The Integrative Genomics Viewer (IGV) is a high-performance visualization tool for interactive exploration of large, integrated genomic datasets. It supports a wide variety of data types, including array-based and next-generation sequence data, and genomic annotations.

### Terminate the Workunit

* To finish the workunit correctly, close the app window or go to the bottom menu click on the Desktop icon -> click Logout (see image below)

<p align="center">
  <img src="https://appreadmesdatabiologynet.blob.core.windows.net/app-readme-resources/Desktop/logout_desktop.png">
</p>

## Supported architectures

* x86_64

## Input files

IGV accepts the following file formats:

* BAM
* BED
* BedGraph
* bigBed
* bigWig
* Birdsuite Files
* broadPeak
* CBS
* Chemical Reactivity Probing Profiles
* chrom.sizes
* CN
* Custom File Formats
* Cytoband
* FASTA
* GCT
* CRAM
* genePred
* GFF/GTF
* GISTIC
* Goby
* GWAS
* IGV
* LOH
* MAF (Multiple Alignment Format)
* MAF (Mutation Annotation Format)
* Merged BAM File
* MUT
* narrowPeak
* PSL
* RES
* RNA Secondary Structure Formats
* SAM
* Sample Info (Attributes) file
* SEG
* SNP
* TAB
* TDF
* Track Line
* Type Line
* VCF
* WIG

## Output files

* JPEG, PNG or SVG files
* BED files
* XML files

## Important notes

* You have to save result files in /scratch/results path.
* After a period of inactivity IGV logout, so you should refresh the page.
* The [igvtools](http://software.broadinstitute.org/software/igv/igvtools) utility provides a set of tools for pre-processing data files and it is accessed by selecting Tools -> Run igvtools.
* The index files must have the same base file name and must reside in the same directory as the file that it indexes.
* IGV requires that both SAM and BAM files be sorted by position and indexed.
* SAM files can be sorted and indexed using igvtools.
  * Note: The .SAI index is an IGV format, and it does not work with samtools or any other application.

## License

[MIT License](https://github.com/igvteam/igv/blob/master/license.txt)

## External link

[Homepage](http://software.broadinstitute.org/software/igv )

__Copyright ©2020. All Rights Reserved. Confidential Databiology Ltd.__
