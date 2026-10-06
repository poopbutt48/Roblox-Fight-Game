# Roblox Fighting Game - Design Document

## Overview
A fast-paced, skill-based fighting game featuring multiple classes with unique playstyles. High skill ceiling achieved through combo systems, spacing, stamina management, and ability timing.

## Classes

### 1. **Warrior** - The Balanced Fighter
- **Playstyle**: Straightforward, rewarding good fundamentals
- **Strengths**: High HP, strong basic attacks, good defense
- **Weaknesses**: Slower attack speed, longer cooldowns
- **Signature Moves**:
  - Power Slash (250 dmg, 1.5s cooldown) - high damage, slow
  - Defensive Stance (blocks 50% dmg for 2s, 3s cooldown)
  - Whirlwind Attack (150 dmg, hits in radius, 4s cooldown)

### 2. **Assassin** - The Precision Striker
- **Playstyle**: Hit-and-run, burst damage, requires positioning
- **Strengths**: High DPS, fast attack speed, high mobility
- **Weaknesses**: Low HP, weak defense, one mistake = death
- **Signature Moves**:
  - Quick Jab (100 dmg, 0.5s cooldown) - fast spam attack
  - Backstab (300 dmg if behind enemy, 3s cooldown) - positioning matters
  - Shadow Dash (teleport 20 studs, 2s cooldown)

### 3. **Mage** - The Ranged Specialist
- **Playstyle**: Kiting, area control, resource management
- **Strengths**: Range, AoE damage, crowd control
- **Weaknesses**: Very low HP, mana limited, slow movement
- **Signature Moves**:
  - Fireball (200 dmg, 1.5s cooldown, 40 mana)
  - Frost Nova (slows enemies by 60%, 3s duration, 4s cooldown)
  - Teleport (15 studs, 3s cooldown, 50 mana)

### 4. **Paladin** - The Support Tank
- **Playstyle**: Protective, team-focused, endurance
- **Strengths**: Highest HP, shields, healing, auras
- **Weaknesses**: Slowest, lower damage output, close-range focused
- **Signature Moves**:
  - Holy Strike (180 dmg, 1s cooldown)
  - Divine Shield (blocks 75% dmg, 3s duration, 5s cooldown)
  - Blessing (heals nearby allies 50 HP, 4s cooldown)

## Core Mechanics

### Combat System
- **Attack Chains**: 3-hit combo system with increasing damage (1x → 1.2x → 1.5x multiplier)
- **Stamina System**: 
  - Max 100 stamina
  - Attacks cost 10-30 stamina based on ability
  - Depleted = 50% slower for 2 seconds
  - Regenerates 15 per second when not attacking
- **Damage Reduction**: Armor reduces incoming damage by 5% per 10 armor points
- **Knockback**: Affects positioning, stronger attacks push harder

### Dodging & Parrying
- **Dodge Roll**: I-frames for 0.5s, travels 15 studs, 2s cooldown
- **Parry**: 0.3s window to block and counter-attack (+20% damage next hit)
- **Spacing**: Attacks deal 10% more damage if you maintain 15-25 studs distance (skill reward)

### Ability System
- **Cooldown Tiers**: 
  - Fast (0.5-1s): spam abilities, low damage
  - Medium (2-3s): core abilities
  - Slow (4-5s): ultimate abilities
- **Resource Management**: Mana for Mage, shields for Paladin, rage for Warrior

### Skill Ceiling Elements
1. **Positioning**: Distance from enemy affects damage and ability effectiveness
2. **Timing**: Optimal attack windows, dodging, ability combos
3. **Stamina Management**: Knowing when to attack vs. when to conserve
4. **Matchup Knowledge**: Class advantages/disadvantages
5. **Micro-spacing**: Moving in/out of range while attacking
6. **Ability Chaining**: Combo abilities for maximum damage
7. **Economy**: Managing resources efficiently over a fight

## Game Modes

### 1v1 Duel
- Best 3 rounds
- 60 second rounds
- First to 300 HP damage wins round
- Respawn after 3 seconds

### 1v1v1 Royale
- Last player standing wins
- Dynamic arena that shrinks over time
- More chaotic, requires awareness

### Team Deathmatch (2v2)
- First team to 10 kills wins
- Coordination matters
- Ability cooldown sharing for team strategy

## Progression System
- **Levels**: Unlock cosmetics and emotes
- **Rank System**: Based on win/loss ratio
  - Bronze → Silver → Gold → Platinum → Diamond → Mythic
- **Cosmetics**: Skins, trails, win animations

## Stats Per Class

| Stat | Warrior | Assassin | Mage | Paladin |
|------|---------|----------|------|---------|
| HP | 150 | 80 | 60 | 200 |
| Speed | 16 | 18 | 14 | 15 |
| Damage | High | Very High | Medium | Medium |
| Range | Melee | Melee | Ranged | Melee |
| Armor | 20 | 5 | 0 | 40 |

## Win Conditions for Skill Expression
- Fast-paced combat rewards reaction time
- Spacing creates skill differential
- Multiple viable strategies per class
- Comeback mechanics (low HP players gain 10% extra damage)
- Prediction plays (reading opponent dodges/abilities)
