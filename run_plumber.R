
pr <- plumber::plumb("plumber.R")
pr$run(host = "127.0.1.1", port = 8080)
