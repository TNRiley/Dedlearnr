# Dedlearnr - a machine learning deduplication package that can help deduplicate
# citations without a human needed.
#Install the remotes packages to enable installation from GitHub
install.packages("remotes")
library(remotes)
remotes::install_github("ESHackathon/CiteSource")
library(CiteSource)

```{r}
#Import citation files from a folder
citation_files <- list.files(path = file.path("C:/Users/trevor.riley/Documents/Rwork/Dedlearnr/RIS/"),
                                recursive = TRUE,
                                pattern = "\\.ris",
                                full.names = TRUE)

#Print citation_files to double check the order in which R imported our files.

citation_files
```

```{r}
file_path <- "C:/Users/trevor.riley/Documents/Rwork/Dedlearnr/RIS/"

metadata_tbl <- tibble::tribble(
  ~files, ~cite_sources, ~cite_labels,
  "Duplicates.ris",   "all",   NA,
  "Primary.ris", "primary", NA,
  "Secondary.ris", "secondary", NA
) %>%
  dplyr::mutate(files = paste0(file_path, files))

citations <- read_citations(metadata = metadata_tbl)

```
```{r}
dedup_results <- dedup_citations(csmcitations,  manual_dedup = FALSE, merge_citations = TRUE)
# unique_citations includes the primary record for all citations, whether they were unique or duplicate and merged
unique_citations <- dedup_results$unique

# citations marked for manual deduplication
#manual_dedup_citations<-dedup_results$manual_dedup

#n_unique provides a dataframe which includes a row for each citation (after internal
# deduplication). Unique citaions will have one row, while citations that were identified
# as duplicate across sources will have a row for each source they were found in.
n_unique <- count_unique(unique_citations)
```

### Create dataframe indicating occurrence of records across sources
```{r}
source_comparison <- compare_sources(unique_citations, comp_type = "sources")
```

### Heatmap
for example, we uploaded 23,372 records from dimensions, after internal deduplication, we find that dimensions contributed 17,945 records.
```{r}
my_heatmap <- plot_source_overlap_heatmap(source_comparison)

my_heatmap
```

### Heatmap Percentage
```{r}
my_heatmap_percent <- plot_source_overlap_heatmap(source_comparison, plot_type = "percentages")

my_heatmap_percent
```

### Plot overlap as an upset plot
```{r}
my_upset_plot <- plot_source_overlap_upset(source_comparison, nintersects = 70, order.by = c( "freq", "degree"), number.angles = 30,)

my_upset_plot
```

### Assess contribution of sources by review stage
Remember that there were 5 strings applied to each DB - this is why we have a
high number of duplicates.
```{r}
my_contributions <- plot_contributions(n_unique,
                                       center = TRUE,
                                       bar_order = c("search")
)

my_contributions

```
