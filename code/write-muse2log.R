#!/usr/bin/env Rscript

# `write-muse2log` writes a table log of the MUSE data with paths 
# Creates a table with two columns
# 	MUSE_ID <character>
# 	PATH <character> - defined by cluster location

cat("Plan for Writing MRN and Paths from MUSE Files!\n")

# Libraries
library(fs)
library(dplyr)
library(vroom)
library(readr)
library(foreach)
library(parallelly)
library(tools)

# Paths
home <- fs::path('/mmfs1','projects','cardio_darbar_chi') # correcting path due to strange link functioning
main <- fs::path("common") # correcting path
muse <- fs::path(home, main, "data", "muse")

# Setup parallelization
nCPU <- parallelly::availableCores()
doParallel::registerDoParallel(cores = nCPU)
cat("Attempt parallelization with", nCPU, "cores\n")

# Create log file
logFile <- fs::path(muse, 'muse', ext = 'log')

# All files in each folder
museList <-
	list.files(path = muse, pattern = '\\.xml$', full.names = TRUE, recursive = TRUE, include.dirs = TRUE) |> # changed command to list files due to error
	na.omit() |>
	unique()

# Update log
if (file.exists(logFile)) {
	old_log <- read.csv(fs::path(muse,'muse.log')) # Load old muse.log file
	museList <- museList[!file_path_sans_ext(museList) %in% fs::path(home,main,old_log$PATH)] # remove file names which are already in the log
	true_false <- FALSE
	} else {true_false <- TRUE} # set t/f value for header names. If file exists, do not add header line

n <- length(museList)
cat("Expect to write out", n, "files\n")
out <-
	foreach(i = 1:n,
					.combine = 'rbind',
					.errorhandling = "remove") %dopar% {
						xml <- fs::as_fs_path(museList[i])

						fn <-
							fs::path_file(xml) |>
							fs::path_ext_remove()

						fp <-
							fs::path_ext_remove(xml) |>
							fs::path_rel(start = fs::path(home, main))


						cat("\tWill write MUSE_ID =", fn, "\n")

						# Return for binding
						cbind(MUSE_ID = fn, PATH = fp)
					}

# Write out the file

out |>
	as.data.frame() |>
	dplyr::distinct() |>
	vroom::vroom_write(
		file = logFile,
		delim = ",",
		col_names = true_false,
		append = TRUE # allow existing file to be updated
	)

cat("\tCompleted writing", n, "MUSE_IDs and paths to log file\n")
