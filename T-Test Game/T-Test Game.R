tTestGame <- function(rounds = 5){
  # ----- Introductory Message -----
  
  cat("
====================================
🎯 Welcome to the T-Test Game: Mark I
====================================

In each round, you’ll see two groups sampled from a population.
Your task: Guess whether the means are *statistically different* (α = 0.05)!

Think visually. Notice the overlap. Feel the uncertainty.
Let’s see how strong your statistical intuition really is!
------------------------------------
\n")
  
  
  # ----- Create Population -----
  N <- 10000 # Population Size
  ss <- seq(30,500,20) # Sample Sizes
  population <- rnorm(N) # Generate the Population DF
  score = 0 # Initialize Score
  smallNoise <- c(rep(0,12),seq(0,1,0.2)) # Added Noise for more variation in samples
  
  # ----------------------------------
  # ----- Start for Loop Here  -------
  # ----------------------------------
  for(i in 1:rounds){
    # Create 2 Samples
    n <- sample(ss,1)# Sample Size
    samp1 <- sample(population, size = n) + sample(smallNoise, 1)
    samp2 <- sample(population, size = n) + sample(smallNoise, 1)
    groups <- c(rep(1,n), rep(2,n))
    df <- data.frame(samples = c(samp1,samp2), groups)
    
    # Calculations
    s1m <- mean(samp1)
    s2m <- mean(samp2)
    
    # ----- Graphs -----
    # Histograms
    par(mfrow = c(1,2))
    hist(samp1, main = "Histograms", col = "lightblue")
    hist(samp2, col = "lavender", add = TRUE)
    
    # Boxplots
    boxplot(samples ~ groups, main = "Boxplots", col = "lightblue", data = df) # Boxplot
    abline(h = mean(population), col = "red", lty = 2)
    
    
    # ----- Hints -----
    cat(
      "\n------------ Hints ------------","\n",
      "\nSample Size: ", n,
      "\nGroup1 Mean: ", s1m,
      "\nGroup2 Mean: ", s2m,
      "\nDifference of Means: ", s1m - s2m,
      "\nGroup1 Variance: ", var(samp1),
      "\nGroup2 Variance: ", var(samp2),
      "\n-------------------------------"
    )
    
    # Run the T-Test
    test <- t.test(samp1, samp2)
    
    # Warning for P-Value Close to Confidence Level
    threshold <- 0.2
    if(abs(test$p.value - 0.05) <= 0.4 & abs(test$p.value - 0.05) >= 0.1  ){
      cat("\nCaution: P-Value Close to Alpha!!!!!")
    }
    
    answer <- readline(prompt = "Is the difference in means statistically significant (Y/N)?")
    print(answer)
    
    cat("\f") # Clear Console
    
    if( (answer %in% c("Y","y")) & test$p.value <= 0.05){
      cat(
        "\nCorrect.",
        "\nP-Value: ", test$p.value,
        "\nThis is statistically Significant"
      )
      score = score + 1
      cat("\nScore: ",score)
      #rstudioapi::sendToConsole("\014")
      
    } else if((answer %in% c("N","n")) & test$p.value >= 0.05){
      cat(
        "\nCorrect.",
        "\nP-Value: ", test$p.value,
        "\nThis is not statistically Significant"
      )
      score = score + 1
      cat("\nScore: ",score)
      #rstudioapi::sendToConsole("\014")
      
    } else{
      print("Incorrect Answer")
      cat(
        "\nP-Value: ", test$p.value,
        "\nScore: ",score
      )
      #rstudioapi::sendToConsole("\014")
    }
    
    
  } # <------------------------ End of For Loop 
  # ----------------------
  # End For Loop Above Me
  # ----------------------
  
  # Results
  cat("\n------------------------------------")
  cat(sprintf("\n🏁 Game Over! You got %d out of %d correct.", score, rounds))
  cat(sprintf("\nAccuracy: %.1f%%\n", 100 * score / rounds))
  cat("------------------------------------\n")
  
  #cat("\nPercent Correct: ", round(score / rounds, 2))
}