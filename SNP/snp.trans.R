library(optparse)
library(biomaRt)

option_list <- list(
  make_option(c("-v", "--version"), 
              default = "grch37",
              type    = "character",
              help    = "out database version, can be grch37 or grch38, default is grch37"),
  make_option(c("-f", "--file"), 
              type = "character", 
              help = "the input file, contains snp rs id, one per line"),
  make_option(c("-o", "--outfile"), 
              type = "character", 
              help = "the output file")
)

parser <- OptionParser(usage = "%prog [options] file", option_list = option_list)
args <- parse_args(parser, positional_arguments = 0)$options

if(args$version == "grch37") {
  host = "grch37.ensembl.org"
} else {
  if(args$version == "grch38") {
    host = "www.ensembl.org"
  } else {
    cat("\n\tthe --version only can be grch37 or grch38\n\n")
    q()
  }
}

rs_id <- read.table(args$file)[,1]

ensembl <- useMart(biomart = "ENSEMBL_MART_SNP",
                 host      = host,
                 path      = "/biomart/martservice",
                 dataset   = "hsapiens_snp")

# attributes can be one or more of listAttributes(ensembl)
res <- getBM(attributes = c('chr_name', 'chrom_start', 'chrom_end', 'refsnp_id', 
                            'minor_allele_freq', "ensembl_transcript_chrom_strand",'allele',
                            "ensembl_gene_stable_id", "ensembl_type"),
             filters = "snp_filter",
             values = rs_id,
             mart = ensembl)

# http://asia.ensembl.org/info/website/upload/bed.html
# first base is 0
# res$chr_name <- paste0("chr", res$chr_name)
# res$chrom_start <- res$chrom_start - 1
# res$chrom_end <- res$chrom_end -1

write.table(res,
            file = args$outfile,
            quote = FALSE, sep = '\t',
            row.names = FALSE, col.names = TRUE)
