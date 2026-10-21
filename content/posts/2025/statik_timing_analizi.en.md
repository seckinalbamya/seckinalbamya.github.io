---
title: "Static Timing Analysis in FPGA"
date: 2025-06-16
slug: /static_timing_analysis_in_fpga/
description: Static Timing Analysis in FPGA
image: images/statik_timing_analiz_pp.png
categories:
  - fpga
tags:
  - fpga
  - timing analysis
  - setup time
  - hold time
  - slack
draft: false
---

**Static Timing Analysis in FPGA:** 

&nbsp;&nbsp;&nbsp;&nbsp;Certain design requirements must be met for an FPGA design to operate safely and without errors. One of the most important of these requirements is timing analysis.

&nbsp;&nbsp;&nbsp;&nbsp;Signals travelling from register to register inside the FPGA, from a register inside the FPGA to external hardware, or from external hardware to a register inside the FPGA must arrive within specific time windows. Timing analysis is the process of determining whether a design will operate reliably, based on the operating frequency defined in the constraint file and the fixed parameters of the target FPGA device.

&nbsp;&nbsp;&nbsp;&nbsp;Timing analysis is an essential step for guaranteeing the stable operation of a design. In a system that does not meet its timing requirements, signals may not be transferred from the source flip flop to the destination flip flop at the correct time, and unexpected behaviour may be observed.

Before moving on to the content of this article, the abbreviations used in the figures and in the text are explained below.
	
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**Tclk**: The time spent on the path from the clock source to the clock input of the flip flop. It varies depending on the design.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**tco** (clock to output) or **tcq** (clock to q): The time elapsed between the rising edge of the clock signal arriving at the flip flop and the Q output. It is a fixed parameter related to the manufacturing technology.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**Tdata**: The time it takes for the data to travel from the Q output of the source flip flop to the D input of the destination flip flop. It varies depending on the design.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**Jitter**: The fluctuation of a signal, particularly at its transition instants.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**Skew**: The time delay caused by signal propagation.

<p align="center">
  <img src="https://vhdlverilog.com/images/timing_analyses/kisaltmalar.png" alt="Representation of the abbreviations used on a timeline" width="500"/>
</p>

<p align="center"><em>Figure 1: Representation of the abbreviations used on a timeline</em></p>

&nbsp;&nbsp;&nbsp;&nbsp;Timing analysis examines whether the signal applied to the input of a flip flop inside the FPGA (the D input) changes within the permitted time window relative to the clock input. The analysis is carried out for two different time windows: the setup and the hold time requirements.
	
**1. Setup time analysis:**
	
A flip flop uses the rising edge of the clock signal to sample the signal applied to its input. It samples the D input at that rising edge and transfers it to the Q output.
	
In a real flip flop, the signal must remain stable for a certain period before the rising edge so that the sampling can be performed correctly. This period is called the setup time (**t<sub>setup</sub>**). It is a fixed parameter related to the manufacturing technology. If the signal changes during this window, which lies immediately before the rising edge of the clock, the flip flop output enters a metastable, unstable state. In this unstable state the output of the flip flop fluctuates between 0 and 1, but after a certain amount of time it resolves and the output settles at a stable value.
	
Maximum allowed data path delay (for setup time) = **T<sub>required\_setup</sub>** = **t<sub>co</sub>** + **T<sub>data</sub>** + **t<sub>setup</sub>** (the pre-clock stability period required by the flip flop) + other factors (jitter, skew, etc.)  
	
&nbsp;&nbsp;&nbsp;&nbsp;**T<sub>required\_setup</sub>** must be ≤ **T<sub>clk</sub>**.

In other words, rearranging the terms of the inequality, it can also be written as:
	
&nbsp;&nbsp;&nbsp;&nbsp;(**t<sub>co</sub>** + **T<sub>data</sub>** + **t<sub>setup</sub>**) ≤ **T<sub>clk</sub>**
	
The point to note here is that as the clock frequency increases, **T<sub>required\_setup</sub>** decreases. Put differently, as the length of the designed data path increases, the achievable clock frequency decreases.
	
**2. Hold time analysis:**

The signal at the input of the flip flop must remain stable for a certain period after being sampled at the rising edge of the clock. This period is called the hold time (**t<sub>hold</sub>**). It is a fixed parameter related to the manufacturing technology. If the signal at the D input of the flip flop changes during this window, the flip flop output enters a metastable, unstable state.
	
Minimum allowed data path delay (for hold time) = **T<sub>required\_hold</sub>** = **t<sub>hold</sub>** (the post-clock stability period required by the flip flop) + other factors (jitter, skew, etc.)  
	
In other words, the time taken for the data to be generated at the source flip-flop and delivered to the destination flip-flop must be greater than or equal to the minimum hold time (plus the system uncertainties):
	
&nbsp;&nbsp;&nbsp;&nbsp;(**t<sub>co</sub>** + **T<sub>data</sub>**) ≥ **T<sub>required\_hold</sub>**
	
The point to note here is that the clock frequency has no effect on **T<sub>required\_hold</sub>**, because it is a parameter related to the sampling performed at the very same clock edge.

In short, setup and hold time checks verify the timing rules governing how long the signal must remain stable around the clock sampling instant. The time windows in which the signal at the flip flop input must stay stable, and in which it is allowed to change, are shown below.

<p align="center">
  <img src="https://vhdlverilog.com/images/timing_analyses/setup_and_hold_gosterim.png" alt="The time windows in which the flip flop input must remain stable and in which it may change(1)" width="600"/>
</p>

<p align="center"><em>Figure 2: The time windows in which the flip flop input must remain stable and in which it may change(1)</em></p>

Before covering how the setup and hold time calculations are performed, several examples are examined below in terms of whether they meet the setup and hold time requirements.

An example that is examined in terms of setup time and that operates without errors is shown in Figure 3 below.

<p align="center">
  <img src="https://vhdlverilog.com/images/timing_analyses/setup_basarili.png" alt="An example that operates without errors in terms of setup time" width="710"/>
</p>

<p align="center"><em>Figure 3: An example that operates without errors in terms of setup time</em></p>

When the signals in the timing diagram are examined, it can be seen that once the REG1.Q signal leaving Register 1 arrives at the REG2.D input, more time than **T<sub>setup</sub>** remains before the next sampling instant. Therefore there is no violation in terms of setup time.

An example that is examined in terms of setup time and that contains a setup time violation is shown in Figure 4 below.

<p align="center">
  <img src="https://vhdlverilog.com/images/timing_analyses/setup_basarisiz.png" alt="An example containing a setup time violation" width="727"/>
</p>

<p align="center"><em>Figure 4: An example containing a setup time violation</em></p>

When the signals in the timing diagram are examined, it can be seen that once the REG1.Q signal leaving Register 1 arrives at the REG2.D input, less time than **T<sub>setup</sub>** remains before the next sampling instant. The signal stability required before sampling is therefore not achieved, and a setup time violation occurs.

An example that is examined in terms of hold time and that operates without errors is shown in Figure 5 below.

<p align="center">
  <img src="https://vhdlverilog.com/images/timing_analyses/hold_basarili.png" alt="An example that operates without errors in terms of hold time" width="710"/>
</p>

<p align="center"><em>Figure 5: An example that operates without errors in terms of hold time</em></p>

When the signals in the timing diagram are examined, it can be seen that after the REG1.Q signal leaving Register 1 arrives at the REG2.D input and is sampled on the next rising clock edge, it stays stable for longer than **t<sub>hold</sub>**. Therefore there is no violation in terms of hold time.

An example that is examined in terms of hold time and that contains a hold time violation is shown in Figure 6 below.

<p align="center">
  <img src="https://vhdlverilog.com/images/timing_analyses/hold_basarisiz.png" alt="An example containing a hold time violation" width="710"/>
</p>

<p align="center"><em>Figure 6: An example containing a hold time violation</em></p>

When the signals in the timing diagram are examined, it can be seen that after the REG1.Q signal leaving Register 1 arrives at the REG2.D input and is sampled on the next rising clock edge, it stays stable for a shorter period than **t<sub>hold</sub>**. The signal stability required after sampling is therefore not achieved, and a hold time violation occurs.

While performing setup and hold time analysis, the analysis tools calculate the slack (the amount of margin) for every data path. The parameters used in these slack calculations and the way they are computed are given below.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**Setup Slack**: Required data transfer time (for setup time) - Data arrival time  ===> The data arrival time must be ≤ **T<sub>required\_setup</sub>**.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**Hold Slack**: Data arrival time - Required data transfer time (for hold time)	 ===> The data arrival time must be ≥ **T<sub>required\_hold</sub>**.

When the setup and hold slack values are positive, the design meets its timing requirements; otherwise the design contains a timing violation.

While positive setup and hold slack values guarantee the stable operation of the design, negative slack values can lead to metastability and unstable states in the system. This causes the outputs of flip flops to become unstable, causes other flip flops sampling those unstable flip flops to capture incorrect values, and can escalate into a failure that brings the whole system down. In a good design it is important to take these analyses into account in order to avoid such failures.

The content and figures in this article draw on the [Understanding Timing Analysis in FPGAs](https://www.youtube.com/watch?v=6D-w8mOttnE) video published on the Altera YouTube channel.
(1): The figure is taken from [vlsi-expert](https://www.vlsi-expert.com/2011/04/static-timing-analysis-sta-basic-part3a.html).
