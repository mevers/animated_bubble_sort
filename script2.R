# Animation of sorting N integers using comb sort in R
# https://rosettacode.org/wiki/Sorting_algorithms/Comb_sort#R
# Author: Maurits Evers (maurits.evers@anu.edu.au)
# Date: 16 September 2019
# Licence: GPL-3
# Dependencies: tidyverse, gganimate
# Tested on R_3.6.1, tidyverse_1.2.1, gganimate_1.0.3


# Randomly sample N values with replacement from the interval [1, N]
N <- 30
set.seed(2018)
x <- sample(N, replace = T)


# Comb sort
lst <- list()
step <- 0
gap <- length(x)
swaps <- 1
while(gap > 1 & swaps == 1) {
    gap <- floor(gap / 1.3)
    if (gap < 1) gap = 1
    swaps <- 0
    i <- 1
    while (i + gap <= length(x)) {
        if( x[i] > x[i + gap]) {
            step <- step + 1
            x[c(i, i + gap)] <- x[c(i + gap, i)]
            swaps <- 1
            lst[[step]] <- data.frame(
                pos = 1:length(x),
                x = x,
                status = replace(rep("keep", length(x)), c(i, i + gap), "swap"))
        }
        i <- i + 1
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
anim_save("animation_comb.gif")
