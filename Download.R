# creating vector of NCBI sequence IDs
ncbi_ids <- c("HQ433692.1", "HQ433694.1", "HQ433691.1")

# loading the rentrez package, must install package first with install.packages()
library(rentrez) 

# creating an object by loading data from NCBI database
Bburg <- entrez_fetch(db = "nuccore", id = ncbi_ids, rettype = "fasta")

# splitting the Bburg data into 3 elements (i.e., one for each sequence)
Sequences <- strsplit(Bburg, split= "\n\n", fixed=TRUE)

# converting the list object of sequences into a vector
Sequences <- unlist(Sequences)

# separating the sequences from their headers and making a data.frame object
header <- gsub("(^>.*sequence)\\n[ATCG].*", "\\1", Sequences)
seq <- gsub("^>.*sequence\\n([ATCG].*)", "\\1", Sequences)
Sequences <- data.frame(Name=header, Sequence=seq)

# removing newline characters from the Name column in the Sequence data frame
library(dplyr) # must have dplyr installed 
Sequences <- Sequences %>%
  mutate(Name=gsub(">", "", Sequences$Name)) %>%
  mutate(Sequence=gsub("\\W|n", "", Sequences$Sequence))

# output Sequences data frame to a file called Sequences.csv
write.csv(Sequences, "Sequences.csv", row.names=F)

