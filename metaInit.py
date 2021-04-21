## Script to run everything
## Ning liu
import sys
import os
import argparse
import shlex, subprocess

parser = argparse.ArgumentParser(description='Initiating script for metaHiC project.')
parser.add_argument('--a', default = '0', help='study accession for the public HiC study.')
parser.add_argument("--csv", help="the csv file that contain all the HiC sample info.")
parser.add_argument("--out", default='./', help="output path.")
parser.add_argument("--sampleList", default = '0', help="file contains sample name instead of using the --a argument")

args = vars(parser.parse_args())
pjname = args['a']

if pjname=='0' and args['sampleList']=='0':
    sys.exit("Script requires either --a or --sampleList argument is used.")

if pjname != '0':
    if not pjname.startswith(('GSE', 'E-MTAB', 'PRJ')):
        sys.exit("Please enter the correct accession id, i.e. start with GSE or E-MTAB.")
    else:
        print("You have chosen study", pjname, "\n")

if not os.path.exists(args['csv']):
    sys.exit("Please enter the correct csv path.")
else:
    print("Loading data from file", args['csv'], "\n")


with open(args['csv'], 'r') as data:
    if args['sampleList']=='0':
        for line in data:
            if len(line) == 1:
                continue
            if pjname == line.strip().split(',')[11]:
                a = line.strip().split(',')
                name = a[0].strip().replace(' ','_')
                url = a[-1]
                org = a[2].strip()
                if org.startswith('Homo'):
                    bwa_index='/hpcfs/users/a1692215/metahic/Genomes/hg38/hg38.fa'
                elif org.startswith('Mus'):
                    bwa_index='/hpcfs/users/a1692215/metahic/Genomes/mm10/mm10.fa'
                elif org.startswith('Gallus'):
                    bwa_index='/hpcfs/users/a1692215/metahic/Genomes/gallusgallus/GRCg6a'
                elif org.startswith('Capra'):
                    bwa_index='/hpcfs/users/a1692215/metahic/Genomes/caprahircus/ARS1'
                elif org.startswith('Sus'):
                    bwa_index='/hpcfs/users/a1692215/metahic/Genomes/susscrofa/Sscrofa11'
                # normal mode or MB mode
                lane_count = (url.count(';')+1)/2
                if lane_count == 1:
                    r1_url = url.split(';')[0]
                    if r1_url.startswith("ftp.sra.ebi"):
                        r1_url = r1_url.lstrip("ftp.sra.ebi.ac.uk")
                    elif r1_url.startswith("ftp://ftp.sra"):
                        r1_url = r1_url.replace("ftp://ftp.sra.ebi.ac.uk","")
                    commandline = 'bash HiCWorkflow.sh ' + r1_url + ' ' + name + ' ' + bwa_index + ' ' + args['out']
                else:
                    urls = []
                    for i in url.split(';'):
                        if i.endswith('_1.fastq.gz'):
                            if i.startswith("ftp.sra.ebi"):
                                i = i.lstrip("ftp.sra.ebi.ac.uk")
                            elif i.startswith("ftp://ftp.sra"):
                                i = i.replace("ftp://ftp.sra.ebi.ac.uk","")
                            urls.append(i)
                    #print(urls)
                    r1_url = ';'.join(j for j in urls)
                    commandline = 'bash HiCWorkflow_MB.sh ' + r1_url + ' ' + name + ' ' + bwa_index + ' ' + args['out']
                print(commandline)                
                commands = shlex.split(commandline)
                process = subprocess.Popen(commands, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
                stdout, stderr = process.communicate()
                x = stdout.decode("utf-8")
                print(x)
    else:
        samples = []
        for i in open(args['sampleList'], 'r'):
            samples.append(i.strip().replace(' ','_'))
        #print(samples)
        for line in data:
            a = line.strip().split(',')
            name = a[0].strip().replace(' ','_')
            if name in samples:
                #print(line)
                url = a[-1]
                #print(url)
                org = a[2].strip()
                if org.startswith('Homo'):
                    bwa_index='/hpcfs/users/a1692215/metahic/Genomes/hg38/hg38.fa'
                elif org.startswith('Mus'):
                    bwa_index='/hpcfs/users/a1692215/metahic/Genomes/mm10/mm10.fa'
                elif org.startswith('Gallus'):
                    bwa_index='/hpcfs/users/a1692215/metahic/Genomes/gallusgallus/GRCg6a'
                elif org.startswith('Capra'):
                    bwa_index='/hpcfs/users/a1692215/metahic/Genomes/caprahircus/ARS1'
                elif org.startswith('Sus'):
                    bwa_index='/hpcfs/users/a1692215/metahic/Genomes/susscrofa/Sscrofa11'
                # normal mode or MB mode
                lane_count = (url.count(';')+1)/2
                if lane_count == 1:
                    r1_url = url.split(';')[0]
                    if r1_url.startswith("ftp.sra.ebi"):
                        r1_url = r1_url.lstrip("ftp.sra.ebi.ac.uk")
                    elif r1_url.startswith("ftp://ftp.sra"):
                        r1_url = r1_url.replace("ftp://ftp.sra.ebi.ac.uk","")                    
                    commandline = 'bash HiCWorkflow.sh ' + r1_url + ' ' + name + ' ' + bwa_index + ' ' + args['out']
                else:
                    urls = []
                    for i in url.split(';'):
                        if i.endswith('_1.fastq.gz'):
                            if i.startswith("ftp.sra.ebi"):
                                i = i.lstrip("ftp.sra.ebi.ac.uk")
                            elif i.startswith("ftp://ftp.sra"):     
                                i = i.replace("ftp://ftp.sra.ebi.ac.uk","")
                            urls.append(i)
                    #print(urls)
                    r1_url = ';'.join(j for j in urls)
                    commandline = 'bash HiCWorkflow_MB.sh ' + r1_url + ' ' + name + ' ' + bwa_index + ' ' + args['out']
                print(commandline)
                commands = shlex.split(commandline)
                process = subprocess.Popen(commands, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
                stdout, stderr = process.communicate()
                x = stdout.decode("utf-8")
                print(x)
