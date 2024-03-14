#!/bin/sh

echo Test: Reverse complement sequence

echo -en "\n============================================\n";

echo Plain Text

for f in *.fast{a,q}; do

    echo read file once with cat
    cat $f > /dev/null;


    echo -en "\n------------------------------------\n";

    echo == SeqKit_old
    echo data: $f;

    memusg -t -H seqkit_old seq -r -p $f -w 0 > $f.seqkit_old.fx ;

    /bin/rm $f.seqkit_old.fx;


    echo -en "\n------------------------------------\n";

    echo == SeqKit
    echo data: $f;

    memusg -t -H seqkit seq -r -p $f -w 0 > $f.seqkit.fx ;

    /bin/rm $f.seqkit.fx;


    echo -en "\n------------------------------------\n";

    echo == SeqKit_j1
    echo data: $f;

    memusg -t -H seqkit seq -r -p $f -w 0 -j 1 > $f.seqkit.fx ;

    /bin/rm $f.seqkit.fx;


    echo -en "\n------------------------------------\n";

    echo == Seqtk
    echo data: $f;

    memusg -t -H seqtk seq -r $f > $f.seqtk.fx ;

    /bin/rm $f.seqtk.fx;


    echo -en "\n------------------------------------\n";

    echo == SeqFu
    echo data: $f;

    memusg -t -H seqfu rc $f > $f.seqfu.fx ;

    /bin/rm $f.seqfu.fx;


    echo -en "\n------------------------------------\n";

    echo == Bioawk
    echo data: $f;

    if [[ "$f" = *fasta* ]]; then
        memusg -t -H bioawk -c fastx '{ print ">"$name"\n"revcomp($seq) }' $f > $f.bioawk.fx ;
    else
        memusg -t -H bioawk -c fastx '{ print ">"$name"\n"revcomp($seq)"\n+\n"reverse($qual)}' $f > $f.bioawk.fx ;
    fi

    /bin/rm $f.bioawk.fx;
done

echo Gzip files

for f in *.fast{a,q}.gz; do

    echo read file once with cat
    cat $f > /dev/null;


    echo -en "\n------------------------------------\n";

    echo == SeqKit_old
    echo data: $f;

    memusg -t -H seqkit_old seq -r -p $f -w 0 -o $f.seqkit_old.gz ;

    /bin/rm $f.seqkit_old.gz;


    echo -en "\n------------------------------------\n";

    echo == SeqKit
    echo data: $f;

    memusg -t -H seqkit seq -r -p $f -w 0 -o $f.seqkit.gz --compress-level 6 ;

    /bin/rm $f.seqkit.gz;


    echo -en "\n------------------------------------\n";

    echo == SeqKit_j1
    echo data: $f;

    memusg -t -H seqkit seq -r -p $f -w 0 -j 1 -o $f.seqkit.gz --compress-level 6 ;

    /bin/rm $f.seqkit.gz;


    echo -en "\n------------------------------------\n";

    echo == Seqtk+pigz
    echo data: $f;

    memusg -t -H seqtk seq -r $f | pigz -p 4 -c > $f.seqtk.gz ;

    /bin/rm $f.seqtk.gz;


    echo -en "\n------------------------------------\n";

    echo == SeqFu+pigz
    echo data: $f;

    memusg -t -H seqfu rc $f | pigz -p 4 -c > $f.seqfu.gz ;

    /bin/rm $f.seqfu.gz;


    echo -en "\n------------------------------------\n";

    echo == Bioawk+pigz
    echo data: $f;

    if [[ "$f" = *fasta* ]]; then
        memusg -t -H bioawk -c fastx '{ print ">"$name"\n"revcomp($seq) }' $f | pigz -c > $f.bioawk.fx.gz ;
    else
        memusg -t -H bioawk -c fastx '{ print ">"$name"\n"revcomp($seq)"\n+\n"reverse($qual)}' $f  | pigz -c > $f.bioawk.fx.gz ;
    fi

    /bin/rm $f.bioawk.fx.gz;
done
