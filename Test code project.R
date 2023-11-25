
test <- project_df[grep('Scien', project_df$job_title, ignore.case = TRUE), ]
test <- test[grep('data', test$job_title, ignore.case = TRUE), ]

test2 <- project_df[grepl('Scien', project_df$job_title, ignore.case = TRUE) & 
                      grepl('Data', project_df$job_title, ignore.case = TRUE),  ]

remove(test)
