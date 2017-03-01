library(DOSE)
library(clusterProfiler)
data(NCG_EXTID2PATHID)
enterzid <- names(NCG_EXTID2PATHID)
symbol <- bitr(enterzid,
               fromType = "ENTREZID",
               toType   = "SYMBOL",
               OrgDb    = "org.Hs.eg.db")
write.table(symbol,
            file = "cancer.genes.txt",
            quote = FALSE,
            row.names = FALSE,
            col.names = TRUE,
            sep = '\t')
