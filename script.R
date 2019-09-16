# Animation of sorting N integers using bubble sort in R
# Author: Maurits Evers (maurits.evers@anu.edu.au)
# Date: 15 September 2019
# Licence: GPL-3
# Dependencies: tidyverse, gganimate
# Tested on R_3.6.1, tidyverse_1.2.1, gganimate_1.0.3


# Randomly sample N values from the interval [1, N]
N <- 20
set.seed(2018)
x <- sample(N)


# Bubble sort
lst <- list()
step <- 0
for (i in 1:(length(x) - 1)) {
    for (j in 1:(length(x) - i)) {
        if (x[j] > x[j+1]) {
            step <- step + 1
            tmp <- x[j]
            x[j] <- x[j + 1]
            x[j + 1] <- tmp
            lst[[step]] <- data.frame(
                pos = 1:length(x),
                x = x,
                status = replace(rep("keep", length(x)), c(j, j + 1), "swap"))
        }
    }
}


# Animate
library(gganimate)
library(tidyverse)
a <- bind_rows(lst, .id = "step") %>%
    mutate(step = factor(step, levels = 1:length(lst))) %>%
    ggplot(aes(pos, x, fill = status)) +
    geom_col() +
    scale_x_continuous(breaks = 1:length(x)) +
    labs(title = "Step: {current_frame}") +
    transition_manual(step) +
    ease_aes("linear")
animate(a, end_pause = 10)
anim_save("animation.png")
