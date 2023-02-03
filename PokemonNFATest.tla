--------------------------- MODULE PokemonNFATest ---------------------------
EXTENDS Naturals, Reals, Integers, Sequences

\*healthOptions = x: x <= 100 /\ x >= 0 x \in NATURALS
\*CONSTANT health
\*ASSUME health \in Nat /\ health <= 100 /\ health >= 0

\*CONSTANT S1;
\*S1 SUBSET Nat;
\*S \in SUBSET Nat;
\*FilterExample == {x \in S1 : x*2 \in S2}

\*CONSTANTS S1
\*ASSUME /\ S1 \subseteq Nat

maxHealth == 100

healthOptions == {x \in Int : x <= maxHealth}
\*\A x \in S1 x <= 100 \*{0,50,100}
aliveHealths == {x \in Nat : x > 0 /\ x <= maxHealth}\*healthOptions - {0} \*{50,100}
healths == healthOptions \times healthOptions

actions == {"PlayerAttack", "EnemyAttack", "Idle"}

VARIABLES playerHealth, enemyHealth

attackDamage == 60


Init ==
  /\ playerHealth = maxHealth
  /\ enemyHealth = maxHealth

Invariant ==  
 /\ <<playerHealth, enemyHealth>> \in healths
\* /\ \E x \in  {playerHealth, enemyHealth} : x \in aliveHealths

PlayerAttack == 
  /\ enemyHealth \in aliveHealths
  /\ <<playerHealth, enemyHealth - attackDamage>> \in healths
  /\ \E x \in  {playerHealth, enemyHealth - attackDamage} : x \in aliveHealths \*Takes out 0,0 as a state
  /\ playerHealth' = playerHealth
  /\ enemyHealth' = enemyHealth - attackDamage

EnemyAttack == 
  /\ playerHealth \in aliveHealths
  /\ <<playerHealth - attackDamage, enemyHealth>> \in healths
  /\ \E x \in  {playerHealth - attackDamage, enemyHealth} : x \in aliveHealths \*Takes out 0,0 as a state
  /\ playerHealth' = playerHealth - attackDamage
  /\ enemyHealth' = enemyHealth

Idle == 
  /\ <<playerHealth, enemyHealth>> \in healths
  /\ playerHealth' = playerHealth
  /\ enemyHealth' = enemyHealth


Next ==
  /\ Invariant
  /\ \/ PlayerAttack
     \/ EnemyAttack
     \/ Idle
 
Spec == Init /\ [][Next]_<<playerHealth, enemyHealth>>

=============================================================================
\* Modification History
\* Last modified Thu Feb 02 21:31:55 EST 2023 by ryan
\* Created Thu Feb 02 11:12:03 EST 2023 by ryan
