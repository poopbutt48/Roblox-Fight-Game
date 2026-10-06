# Roblox Fighting Game - Project Documentation

## Project Overview
A high-skill-ceiling 1v1 fighting game for Roblox featuring 4 unique classes, advanced combat mechanics, and competitive gameplay. The game emphasizes spacing, timing, stamina management, and ability chaining.

## Architecture

### Core Systems
1. **GameController** - Match lifecycle, player spawning, arena management
2. **CombatSystem** - Combat mechanics, damage calculation, ability execution
3. **UIManager** - HUD rendering, stat displays, cooldown trackers

### Key Mechanics
- **Combo System**: 3-hit chains with damage multipliers (1x, 1.2x, 1.5x)
- **Stamina**: 100 max, 15/s regen, 10-40 cost per ability, 50% speed penalty when depleted
- **Spacing Bonus**: +10% damage at optimal 15-25 stud range
- **Positioning**: Backstabs deal 1.5x, distance affects effectiveness
- **Cooldowns**: Ability-based (0.5-5s depending on power)

### Class Balance Matrix
```
Warrior   (150 HP, 20 AR, 16 SPD) - Balanced, strong defense
Assassin  (80 HP, 5 AR, 18 SPD)   - Burst damage, high mobility  
Mage      (60 HP, 0 AR, 14 SPD)   - Ranged, AoE, resource limited
Paladin   (200 HP, 40 AR, 15 SPD) - Tank, shields, healing
```

## File Structure
```
src/
  ├── GameController.lua  - Main game loop, match management
  ├── CombatSystem.lua    - Combat mechanics, damage, abilities
  └── UIManager.lua       - HUD, health bars, cooldowns

docs/
  └── [Future: Balancing guides, ability details, matchup charts]

GAME_DESIGN.md   - Complete design document with all mechanics
README.md        - Setup instructions and player guide
CLAUDE.md        - This file
```

## Development Notes

### High Skill Ceiling Design
The game achieves depth through:
1. **Multi-dimensional decision-making** (attack/dodge/ability/reposition)
2. **Resource scarcity** (stamina limits reckless play)
3. **Positioning matter** (spacing provides 10% damage bonus)
4. **Prediction gameplay** (reading opponent's next move)
5. **Matchup knowledge** (learning class advantages)
6. **Ability sequencing** (optimal ability combos)

### Performance Considerations
- Character data cleaned up on death to prevent leaks
- Heartbeat loop for smooth animations (not Stepped)
- Debounces on abilities to prevent exploit spam
- Batch damage calculations

### Testing Checklist
- [ ] Combo system triggers at correct times
- [ ] Stamina depletes and regenerates correctly
- [ ] Spacing bonus applies (15-25 studs)
- [ ] All 4 classes are balanced (~50% win rate each)
- [ ] Abilities execute on correct keybinds
- [ ] Dodge I-frames work properly
- [ ] No memory leaks on character death
- [ ] UI updates smoothly with combat
- [ ] Damage calculations match expected values

## Future Enhancements

### Immediate (MVP)
- [ ] Projectile system for Mage abilities
- [ ] Hit feedback (knockback, particles)
- [ ] Sound effects for abilities
- [ ] Character customization (basic skins)

### Short-term (Season 1)
- [ ] Ranking system (Bronze-Mythic)
- [ ] Leaderboards
- [ ] Match replays
- [ ] Cosmetics shop
- [ ] Team Deathmatch (2v2)

### Long-term (Post-Launch)
- [ ] 5th+ classes
- [ ] Ability loadouts/customization
- [ ] Tournament mode
- [ ] Spectator system
- [ ] Cross-platform progression

## Balance Tuning

### Key Metrics to Monitor
- Win rate per class (target: 50%)
- Most-banned class (indicates OP)
- Ability usage rates
- Average match duration (target: 60-90s)
- Combo frequency

### Patch Philosophy
- Buff weak classes before nerfing strong ones
- Small changes (5-10% adjustments) first
- Monitor impact for 1 week before next patch
- Community feedback matters

### Ability Balancing Framework
```
Power Level = Damage × (1 / Cooldown) × ResourceCost
              
Mage Fireball: 200 × (1/1.5s) × 40 mana = 266 efficiency
Warrior Slash: 250 × (1/1.5s) × 30 stamina = 417 efficiency
Assassin Jab: 100 × (1/0.5s) × 10 stamina = 2000 spam efficiency
```

## Known Issues
- Projectile system not yet implemented (Mage abilities)
- Particle effects missing
- Sound system not integrated
- No replay system yet

## Code Style Guide
- Use descriptive variable names (not `d`, `x`, `h`)
- Comments only for non-obvious logic (WHY, not WHAT)
- Luau types optional but recommended for clarity
- Tab indentation (Roblox standard)
- Local functions over globals

## Testing Environment
- Test in Roblox Studio with 2+ clients
- Verify all classes play smoothly
- Check for lag at 50+ players (scale testing)
- Monitor memory usage over time

---

**Last Updated**: 2026-10-06
**Version**: 0.1.0 (MVP)
**Status**: Initial development complete, ready for testing
