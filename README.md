# Benchmark

## Tools

- [seqtk](https://github.com/lh3/seqtk/), version [v1.4](https://github.com/lh3/seqtk/releases/tag/v1.4).
- [seqfu](https://github.com/telatin/seqfu2), version [v1.20.0](https://github.com/telatin/seqfu2/releases/tag/v1.20.0).
- [seqkit](https://github.com/shenwei356/seqkit), version [v2.6.1](https://github.com/shenwei356/seqkit/releases/tag/v2.6.1) and [v0.3.1.1](https://github.com/shenwei356/seqkit/releases/tag/v0.3.1.1).

Notes:

- `seqfu` and `seqtk` do not support wrapped (fixed line width) outputting, so `seqkit` uses
`-w 0` to disable outputting wrapping.
- `seqtk` and `seqfu` do not suppport gzip-compressed output, so we pipe the results to `gzip` or [`pigz`](https://zlib.net/pigz/) (a faster gzip).

Script [`memusg`](https://github.com/shenwei356/memusg) is used to assess running time
and peak memory usage.

## Datasets

Datasets:

- Human genome. Human T2T genomes [T2T-CHM13v2.0_genomic](https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/009/914/755/GCA_009914755.4_T2T-CHM13v2.0/GCA_009914755.4_T2T-CHM13v2.0_genomic.fna.gz).
- Bacteria genomes. Food associated representative sequences from [proGenomes 3](https://progenomes.embl.de/data/habitats/representatives.food_associated.contigs.fasta.gz). (not used due to results in bacteria genomes and long reads are similar.)
- ONT reads. Metagenomic reads from a mock community: [ERR5396170](http://ftp.sra.ebi.ac.uk/vol1/fastq/ERR539/000/ERR5396170/ERR5396170.fastq.gz), it is down-sampled for keeping 10 percents reads with `seqkit sample -p 0.1`.
- Illumina reads. Metagenomic reads from a mock community: [SRR8359173](https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR835/003/SRR8359173/). Pair-end reads are merged.

Summary:

    file                       format  type    num_seqs        sum_len  min_len        avg_len      max_len
    bacteria_genomes.fasta.gz  FASTA   DNA       30,114  2,103,539,345      100       69,852.5    8,545,929
    human_genome.fasta.gz      FASTA   DNA           25  3,117,292,070   16,569  124,691,682.8  248,387,328
    long_reads.fastq.gz        FASTQ   DNA      543,504  1,797,973,978       90        3,308.1      170,525
    short_reads.fastq.gz       FASTQ   DNA   10,038,314  1,254,789,250      125            125          125

## Benchmarks

Benchmarks and commands:

1. Summary information of FASTA/Q files, including the number of sequences and bases.
    - `seqfu  count $input > $output`, `seqfu count` counts the number of sequences
    - `seqtk   size $input > $output`, `seqtk size` counts the number of sequences and bases
    - `seqkit stats $input > $output`, `seqkit stats` counts the number of sequences and bases and more.
2. FASTA/Q file reading and writing.
    - For plain text:
        - `seqfu  cat       $input > $output`
        - `seqtk  seq       $input > $output`
        - `seqkit seq -w 0  $input > $output`
    - For gzip-compressed files:
        - `seqfu  cat      $input.gz | pigz -c > $output.gz`
        - `seqtk  seq      $input.gz | pigz -c > $output.gz`
        - `seqkit seq -w 0 $input.gz -o $output.gz`
3. Reverse complementary sequence computation.
    - For plain text:
        - `seqfu  rc             $input > $output`
        - `seqtk  seq -r         $input > $output`
        - `seqkit seq -r -p -w 0 $input > $output`
    - For gzip-compressed files:
        - `seqfu  rc             $input.gz | pigz -c > $output.gz`
        - `seqtk  seq -r         $input.gz | pigz -c > $output.gz`
        - `seqkit seq -r -p -w 0 $input.gz -o $output.gz`

Tests were repeated 3 times and average time and memory usage were recorded.

Results:

<img src="benchmark.jpg" alt="" width="850" align="center" />

Notes:

- `seqkit` uses 4 threads by default.
- `seqkit_j1` uses 1 thread.
- `seqkit_old` refers to SeqKit v0.3.1.1.
- `seqfu` is single-threaded.
- `seqtk` is single-threaded.
- `seqtk+pigz`: `seqtk` pipes data to the multithreaded `pigz` which uses 4 threads here.
- `seqfu+pigz`: `seqfu` pipes data to the multithreaded `pigz` which uses 4 threads here.
 
## Steps

    # run the benchmarks
    ./run.pl -n 3 run_benchmark_*.sh --outfile benchmark.tsv

    # not used tests: bacteria_genomes
    # not used tool: seqfu+gzip and seqtk+gzip
    cat benchmark.tsv \
        | csvtk grep -t -f app     -r -v -p gzip \
        | csvtk grep -t -f dataset -r -v -p bacteria \
        > benchmark.filtered.tsv

    # plot
    ./plot.R -i benchmark.filtered.tsv --dpi 600 --width 10 --height 5 -o benchmark.jpg
