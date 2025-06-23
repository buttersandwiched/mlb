/*
 Stats That would be good to track in a db table:

 1) every single "play" with play defined as:
    - an action performed by the pitcher, batter, umpire or team(s)
        - this includes: pitch, batter/pitcher timeout, step-off, pickoff, batter/pitcher violation, play call review,
   - "non-P

 2) every pitch thrown with all possible data points associated with it, including
    - pitch type, ball speed (when thrown and at contact, if possible), spin rate, strike zone coordinates,
      outcome (ball, called strike, swinging strike, foul)

 3) every hit ball with all possible data points with it, including
    - bat speed, ball speed, total distance, coordinates of landing zone, coordinates of strike zone where hit,
      launch angle

 4) movement of a runner which would include:
    - advancements to first, second, third or home
    - pickoffs
    - stolen bases, bases caught stealing

 5) Aggregate tables with stats such as
    a) plate appearances
    b) pitcher appearances
    c) runs (earned and unearned)
    d) errors


 */