#1.1 How many 100bp reads are needed to sequence a 1Mbp genome to 3x coverage? 
#   3x converage * 1Mb = 3Mb
#   3Mb/100bp =30,000 reads

#1.4
- In your simulation, how much of the genome has not been sequenced (has 0x coverage)?
there are just under 50,000 positions which have not been sequenced.
- How well does this match Poisson expectations? How well does the normal distribution fit the data?
The Poisson is very close to the normal line, with the poisson showing values just slightly lower than the normal frequency counts. The trend remains similar, however.

#1.5
- In your simulation, how much of the genome has not been sequenced (has 0x coverage)?
The coverage has improved substantially than in 3x coverage - there are near zero positions which have not been covered at least once.
- How well does this match Poisson expectations? How well does the normal distribution fit the data?
The Poisson distribution matches the graph/normal very closely, with the difference between the two lines decreasing from the 3x graph.

#1.6
- In your simulation, how much of the genome has not been sequenced (has 0x coverage)?
In this simulation, none of the genome has not been sequenced. The lowest coverage is around 15x.
- How well does this match Poisson expectations? How well does the normal distribution fit the data?
The Poisson expectations match exactly, while the normal distribution is tighter.

#2.4
dot -Tsvg edges.txt > output.svg

#2.5
Assume that the maximum number of occurrences of any 3-mer in the actual genome is five. Using your graph from Step 2.4, write one possible genome sequence that would produce these reads.
TTCTTATTCATTGATTT

#2.6
In a few sentences, what would it take to accurately reconstruct the sequence of the genome?
The 3x coverage was insufficient as there were positions which had no coverage. Moving forward, the 10x coverage had fewer positions with no coverage but the Poisson distribution matched the data slightly less. Finally, the 30x coverage had no regions of zero coverage and the Poisson distribution matched the data almost exactly. In practice, a happy medium between the 10x and 30x coverage would likely be the most accurate AND efficient/economical (if these are not a concern,  30x should be used for its highest accuracy).