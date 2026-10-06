# 🔥 Roblox Fighting Game - High Skill Ceiling Combat Arena

A fast-paced, competitive 1v1 fighting game built for Roblox with multiple classes, advanced combat mechanics, and a high skill ceiling that rewards positioning, timing, and resource management.

## 🎮 Features

### Four Unique Classes
- **Warrior**: Balanced fighter with strong defense and high damage
- **Assassin**: Glass cannon with lightning-fast attacks and mobility
- **Mage**: Ranged specialist with crowd control and area denial
- **Paladin**: Support tank with shields and healing

### Advanced Combat System
- **Combo System**: 3-hit combos with escalating damage multipliers (1x → 1.2x → 1.5x)
- **Stamina Management**: Every action drains stamina; poor stamina control = -50% speed
- **Spacing Mechanics**: Optimal range attacks deal +10% bonus damage (15-25 studs)
- **Positioning Rewards**: Backstabs deal 1.5x damage; maintaining distance is skill expression
- **Dodge Mechanics**: I-frame rolls with 2-second cooldowns
- **Attack Chaining**: Smooth ability combos and sequences

### Skill Ceiling Elements
1. **Timing** - Dodge opponent abilities, land attacks during windows
2. **Spacing** - Maintain optimal distance for damage bonuses
3. **Resource Economy** - Stamina and cooldown management
4. **Prediction** - Read opponent movements and abilities
5. **Class Matchups** - Learn advantage/disadvantage scenarios
6. **Ability Combos** - Chain abilities for devastating effects
7. **Momentum** - First strike often determines fight outcome

### Game Modes
- **1v1 Duels** - Best of 3 rounds (60 seconds each)
- **1v1v1 Royale** - Last player standing wins
- **Team Deathmatch** - 2v2 coordination-based combat

### Progression System
- **Ranking System**: Bronze → Silver → Gold → Platinum → Diamond → Mythic
- **Cosmetics**: Skins, emotes, victory animations
- **Stats Tracking**: Win rates and performance metrics

## 📋 Installation & Setup

### Prerequisites
- Roblox Studio
- Basic Lua knowledge (optional for customization)

### Setup Instructions

1. **Create a new Roblox place** in Studio
2. **Create folder structure**:
   ```
   - StarterPlayer
     - StarterCharacterScripts
       - CharacterHandler (Script)
     - StarterPlayerScripts
       - PlayerHandler (LocalScript)
   - ServerScriptService
     - GameController (Script)
     - CombatSystem (ModuleScript)
     - UIManager (ModuleScript)
   ```

3. **Copy the scripts**:
   - `src/GameController.lua` → ServerScriptService
   - `src/CombatSystem.lua` → ServerScriptService (as ModuleScript)
   - `src/UIManager.lua` → ServerScriptService (as ModuleScript)

4. **Player Setup Script** (StarterPlayer > StarterPlayerScripts > PlayerHandler):
   ```lua
   local GameController = require(game:GetService("ServerScriptService"):WaitForChild("GameController"))
   GameController:Init()
   ```

5. **Publish & Test**!

## 🎯 Game Balance

### Base Stats by Class

| Stat | Warrior | Assassin | Mage | Paladin |
|------|---------|----------|------|---------|
| **HP** | 150 | 80 | 60 | 200 |
| **Armor** | 20 | 5 | 0 | 40 |
| **Speed** | 16 | 18 | 14 | 15 |
| **Attack Speed** | Slow | Fast | Medium | Medium |
| **Range** | Melee | Melee | Ranged | Melee |

### Class Matchups
```
Warrior > Mage (close range advantage)
Assassin > Warrior (burst > tank)
Mage > Assassin (kiting > mobility)
Paladin > Assassin (tanky + healing)
```

## 🕹️ Controls

```
LEFT CLICK    - Attack
SPACE         - Dodge Roll
Q             - Ability 1 (Varies by class)
E             - Ability 2 (Varies by class)
R             - Ability 3 (Varies by class)
SHIFT         - Sprint (when implemented)
```

## 🔧 Combat Mechanics Breakdown

### Stamina System
- Max: 100 stamina
- Regeneration: 15 per second (when not attacking)
- Attack cost: 10-40 per ability
- **Depleted state**: When stamina hits 0, movement/attack speed reduced by 50% for 2 seconds
- **Strategic element**: Knowing when to back off and regen is key

### Combo System
- Hits reset after 1.5 seconds of not attacking
- Multipliers: Hit 1 (1x) → Hit 2 (1.2x) → Hit 3 (1.5x)
- Hitting enemies extends your reach by 5 studs
- Rewards continuous, aggressive play

### Damage Calculation
```
Final Damage = Base Damage × Combo Multiplier × Spacing Bonus × (1 - Armor Reduction)
```

### Class Abilities

#### Warrior
- **Power Slash** (1.5s CD): 250 damage, slow but powerful
- **Defensive Stance** (3s CD): Blocks 50% damage for 2 seconds
- **Whirlwind** (4s CD): 150 damage in 20 stud radius

#### Assassin
- **Quick Jab** (0.5s CD): 100 damage, spam-able
- **Backstab** (3s CD): 300 damage if attacking from behind
- **Shadow Dash** (2s CD): Teleport 20 studs forward

#### Mage
- **Fireball** (1.5s CD): 200 damage projectile
- **Frost Nova** (4s CD): Slows all enemies by 60% for 3 seconds
- **Teleport** (3s CD): Escape spell, 15 studs range

#### Paladin
- **Holy Strike** (1s CD): 180 damage, consistent DPS
- **Divine Shield** (5s CD): Blocks 75% damage for 3 seconds
- **Blessing** (4s CD): Heals nearby allies for 50 HP

## 💡 Strategy Tips

### For Beginners
1. Master your class's core attacks before using abilities
2. Watch stamina bar - never get caught depleted
3. Learn optimal spacing (15-25 studs) for damage bonus
4. Practice dodging in safe duels first

### For Advanced Players
1. **Spacing Manipulation**: Force opponents into bad range, maintain optimal distance
2. **Ability Chaining**: Combo abilities that stun/slow into your damage abilities
3. **Stamina Punishes**: Aggressive spam stamina to force opponents into depleted state
4. **Prediction Reading**: Anticipate dodges and chain attacks through them
5. **Class Countering**: Pick favorable matchups; learn all class strengths/weaknesses

### High-Level Play
- Frame data matters (attack speed differences)
- Resource economy > raw damage (manage stamina/cooldowns)
- Positioning determines 70% of fight outcome
- Comebacks are possible but require perfect reads
- Tournament play emphasizes consistency and fundamentals

## 🚀 Performance Tips

- Use RunService.Heartbeat for smooth animations
- Batch damage calculations to reduce server load
- Clean up character data on death to prevent memory leaks
- Use debounces on ability casts to prevent spam exploits

## 📦 File Structure

```
Roblox-Fight-Game/
├── GAME_DESIGN.md          # Complete game design document
├── README.md               # This file
├── src/
│   ├── GameController.lua  # Main game loop & match management
│   ├── CombatSystem.lua    # Combat mechanics & damage calculations
│   └── UIManager.lua       # HUD and UI updates
└── docs/
    ├── BALANCING.md        # Balance notes and tuning guide
    └── EXTENDING.md        # Guide for adding new content
```

## 🛠️ Customization & Extending

### Adding a New Class
1. Add class stats to `CombatSystem:SetupClass()`
2. Define abilities array with cooldowns/costs
3. Add ability execution logic to `ExecuteAbility()`
4. Test matchups against existing classes

### Adjusting Balance
- Modify COMBAT_CONFIG values for global tweaks
- Change class stats in classStats table
- Adjust ability cooldowns/damage in ability definitions

### Adding New Mechanics
- Extend `PerformAbility()` for new ability types
- Add status effects (stun, slow, burn) in damage phase
- Implement projectile system for ranged attacks

## 🐛 Known Issues & Future Features

### TODO
- [ ] Projectile system for Mage
- [ ] Particle effects and hit feedback
- [ ] Sound effects and music
- [ ] Spectator mode
- [ ] Replay system
- [ ] Leaderboards
- [ ] Tournament brackets
- [ ] Custom game creation
- [ ] Ability customization (loadouts)
- [ ] More classes and abilities

### Balance Patches
- Fine-tune ability cooldowns based on win rates
- Adjust armor effectiveness if meta becomes too tank-heavy
- Monitor spacing bonus - may need reduction if too powerful

## 📊 Telemetry & Analytics

Track these metrics to improve balance:
- Win rates per class
- Average game duration
- Most-used abilities
- Ability success rates
- Spacing effectiveness
- Combo effectiveness

## 🎓 Learning Resources

- **Frame Data**: Document each ability's startup, active, and recovery frames
- **Matchup Guides**: Create guides for each class pair
- **Tournament VODs**: Analyze professional play
- **Replay System**: Learn from your losses

## 💬 Community & Feedback

- Monitor player feedback on ability balance
- Run weekly balance patches if needed
- Host community tournaments
- Feature montages of cool plays

## 📝 License & Attribution

This fighting game was created as a fun, skill-based Roblox experience. Feel free to extend, customize, and share!

---

**Happy Fighting! 🥊** May the best player win. Remember: spacing is key, stamina is life, and combos win fights.
