+++
date = '2025-03-05T18:09:18+05:30'
draft = false
title = '2025 Mar 7 :: Automatically Verifying Replication-aware Linearizability'
author = 'Vimala Soundarapandian'
+++

#### **Talk 1**
- **Topic:** Automatically Verifying Replication-aware Linearizability

- **Description:** Data replication is essential for fault tolerance and low latency in decentralized applications. Replicated Data Types (RDTs) have emerged as a principled approach for developing replicated implementations of basic data structures such as counters, flags, sets, maps, etc. While RDT correctness is often defined by strong eventual consistency, replication-aware linearizability offers a more expressive specification, ensuring that replicas reflect a state obtained by linearizing updates. In this work, we develop a novel fully automated technique for verifying replication-aware linearizability for Mergeable Replicated Data Types (MRDTs). We identify novel algebraic properties for MRDT operations and the merge function, which go beyond the standard notions of commutativity, associativity, and idempotence for proving an implementation to be linearizable. We also develop a novel inductive method called bottom-up linearization for automated verification. We have successfully applied our approach to a number of complex RDT implementations.


- **Time** 5 pm to 6 pm (IST)  
- **Presenter:** Vimala Soundarapandian  
- **About the Presenter:** https://sites.google.com/view/vimala90/
- **URL** : https://meet.google.com/jvt-nyxg-wra 
