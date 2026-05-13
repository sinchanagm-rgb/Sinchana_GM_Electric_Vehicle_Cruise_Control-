# Electric Vehicle Cruise Control using PID — MATLAB

**Team Members:** Sinchana G M, Ameera A Syed  
**Event:** Control Craft Hackathon — BNM Institute of Technology  
**Problem Statement:** PS2 — Electric Vehicle Cruise Control  

---

## Problem Overview

Design a cruise control system to maintain constant vehicle speed under varying road conditions, including disturbances such as road slope introduced at t = 10s.

---

## System Model

The vehicle dynamics are represented as a first-order transfer function:

```
G(s) = 1 / (5s + 1)
```

- **Input:** Throttle control
- **Output:** Vehicle speed
- **Disturbance:** Road slope introduced at t = 10s

---

## Dependencies

- MATLAB R2020 or later
- Control System Toolbox

---

## How to Run

1. Open MATLAB
2. Run `control_sys.m`
3. All figure windows will appear showing the complete analysis
4. Check command window for stepinfo() performance metrics

---

## Our Approach

### Step 1 — Open Loop Analysis
We first analyzed the open-loop response. The system settled at amplitude 1.0 but took approximately 25 seconds — far too slow for practical cruise control. There was no overshoot but also no self-correction capability under disturbance.

### Step 2 — Closed Loop without Controller
Closing the loop with unity feedback reduced settling time but introduced a steady-state error of 0.5 — the speed never reached the target. This confirmed the need for an integral term.

### Step 3 — Auto PID using pidtune()
Using MATLAB's `pidtune()`, we obtained a PI controller (Kp=1.43, Ki=0.519, Kd=0). This eliminated steady-state error but left 6% overshoot — slightly above the 5% spec.

### Step 4 — Manual Tuning
We manually added a derivative term and increased Kp to improve transient response:
- **Kp = 2** — increased for faster rise time (reduced from 9.6s to 4.5s)
- **Ki = 0.519** — retained to maintain zero steady-state error
- **Kd = 0.1** — added to damp overshoot from 6% down to 2%

### Step 5 — Disturbance Rejection
A road slope disturbance was introduced at t=10s. The controller successfully rejected the disturbance and recovered vehicle speed back to the target value, demonstrating robust closed-loop performance.

### Step 6 — Stability Analysis (Bode Plot)
Bode analysis confirmed:
- **Gain Margin = Inf** — system remains stable under any gain variation
- **Phase Margin = 84.6°** — well above the 45° industry standard, indicating excellent stability robustness

### Step 7 — Disturbance Tradeoff Analysis
We tested the controller under three slope magnitudes (-0.1, -0.2, -0.3) and investigated whether increasing Ki could improve rejection for steeper slopes.

**Finding:** Increasing Ki from 0.519 to 1.5 improved disturbance rejection slightly but caused overshoot to increase to ~20%, violating the <5% spec. Our original Ki=0.519 was the better balanced choice — meeting all specs while maintaining adequate disturbance rejection. This tradeoff demonstrates a fundamental control design principle: stronger integral action improves steady-state performance but degrades transient response.

---

## Final Controller Parameters

| Parameter | Value | Reason |
|-----------|-------|--------|
| Kp | 2 | Faster rise time without excess overshoot |
| Ki | 0.519 | Eliminates steady-state error, balanced tradeoff |
| Kd | 0.1 | Damps overshoot from 6% to 2% |

---

## Performance Metrics

| Metric | Specification | Achieved |
|--------|--------------|----------|
| Overshoot | < 5% | 2.07% ✅ |
| Steady-state error | < 2% | 0% ✅ |
| Transient response | Smooth | ✅ |
| Disturbance rejection | Stable | ✅ |
| Gain Margin | > 0 dB | Infinite ✅ |
| Phase Margin | > 45° | 84.6° ✅ |

---

## Results — Plot Summary

| Plot | Description |
|------|-------------|
| `01_open_loop.png` | Open loop — slow, no feedback |
| `02_closed_loop_no_controller.png` | Closed loop — steady-state error 0.5 |
| `03_closed_loop_PID.png` | Closed loop with pidtune() PI controller |
| `05_tuned_PID.png` | Manually tuned PID — meets all specs |
| `06_controller_comparison.png` | No controller vs PI vs Tuned PID |
| `07_disturbance_response.png` | System response with slope at t=10s |
| `08_bode_plot.png` | Bode plot — gain and phase margin |
| `09_multiple_disturbances.png` | Disturbance rejection for slopes -0.1, -0.2, -0.3 |
| `10_high_Ki_comparison.png` | Tradeoff analysis — higher Ki vs original Ki |

---

## Key Learnings

- Proportional gain speeds up response but increases overshoot
- Integral term eliminates steady-state error but too much causes oscillation
- Derivative term damps overshoot — critical for meeting the <5% spec
- Phase margin of 84.6° confirms the system is robustly stable
- Engineering design always involves tradeoffs — Ki tuning demonstrates this clearly
