def tTestGame(rounds=5):

    import numpy as np
    import pandas as pd
    import random as rand
    from scipy import stats
    from IPython.display import clear_output
    import matplotlib.pyplot as plt

    # ---------- Introductory Message ----------
    print(
        "====================================\n"
        "🎯 Welcome to the T-Test Game: Mark I\n"
        "====================================\n"
        "In each round, you’ll see two groups sampled from a population.\n"
        "Your task: Guess whether the means are *statistically different* (α = 0.05)!\n"
        "Think visually. Notice the overlap. Feel the uncertainty.\n"
        "Let’s see how strong your statistical intuition really is!\n"
        "------------------------------------\n"
    )

    # ---------- Create Population ----------
    N = 10000  # Population Size
    population = np.random.normal(size=N)  # Normally Distributed Population
    score = 0  # Initialize Score

    # ---------- Game Loop ----------
    import sys

    for i in range(rounds):
      clear_output(wait=True)           # clear at start of round

      n = round(rand.uniform(30, 500)) # Sample Size
      sample1 = np.random.choice(population,
                                 n,
                                 replace=False) + np.random.normal(size = n)
      sample2 = np.random.choice(population,
                                 n,
                                 replace=False) + np.random.normal(loc = np.random.choice([0,0,0.2,0.5,0.8,1]),size = n)

      mean1 = np.mean(sample1)
      mean2 = np.mean(sample2)
      variance1 = np.var(sample1)
      variance2 = np.var(sample2)

      # --- Boxplot with styling ---
      plt.close("all")
      fig, ax = plt.subplots(figsize=(6, 4), facecolor='white')
      ax.boxplot(
        [sample1, sample2],
        patch_artist=True,
        labels=["Group 1", "Group 2"],
        boxprops=dict(facecolor='lightblue', color='black'),
        medianprops=dict(color='black'),
        whiskerprops=dict(color='black'),
        capprops=dict(color='black'),
        flierprops=dict(markerfacecolor='lightblue', marker='o',
                        markersize=5, markeredgecolor='black')
      )

      ax.axhline(np.mean(population), color='red', linestyle='dotted', linewidth=2)
      ax.set_facecolor('white')
      ax.grid(True, linestyle=':', color='lightgray')
      plt.title(f"Round {i + 1}: Group Comparison")

      plt.show(block=False)
      plt.pause(0.5)   # <-- give UI time to render

      # --- Hints ---
      print(
        f"---------- Round {i+1} ----------\n"
        f"Mean 1: {mean1:.3f}\n"
        f"Mean 2: {mean2:.3f}\n"
        f"Difference of Means: {mean2 - mean1:.3f}\n"
        f"Variance 1: {variance1:.3f}\n"
        f"Variance 2: {variance2:.3f}\n"
        "--------------------------"
    )

      t_test = stats.ttest_ind(sample1, sample2)
      if 0.04 < t_test.pvalue < 0.06:
        print("⚠️  Warning: P-Value is Close to Alpha!!!")

      sys.stdout.flush()  # <-- ensure print output appears before prompt
      answer = input("Is the difference statistically significant? (y/n): ")

      if answer.strip().lower() == "y" and t_test.pvalue < 0.05:
        print(f"✅ Correct! Significant difference.\nP-Value: {t_test.pvalue:.4f}")
        score += 1
      elif answer.strip().lower() == "n" and t_test.pvalue >= 0.05:
        print(f"✅ Correct! Not significant.\nP-Value: {t_test.pvalue:.4f}")
        score += 1
      else:
        print(f"❌ Incorrect.\nP-Value: {t_test.pvalue:.4f}")

      if i < rounds - 1:
        input("\nPress Enter to continue to the next round...")


    # ---------- Results ----------
    print(
        "-----------------------------\n"
        "----- Game Over! -----\n"
        f"Score: {score}\n"
        f"Percent Correct: {score / rounds * 100:.2f}%\n"
        "-----------------------------"
    )
