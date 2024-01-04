import ./types
import std/strformat
import std/math
import std/setutils
import std/sequtils
import std/strutils

type
  # use floats for everything b/c this is also used for stats modifications which can be floats
  Stats* = object
    # base stats
    supply*: float = 0
    hp*: float = 0
    vision*: float = 1500
    speed*: float = 0
    shields*: float = 0
    energy*: float = 0
    damageReduction*: float = 0

    # attack
    damage*: float = 0
    bonuses*: seq[BonusForTag] = @[]
    attacks*: float = 1
    range*: float = 1
    reload*: float = 1
    splash*: Splash = (0, 0)

  Entity* = ref object
    name*: string
    factions*: set[Faction] = {Neutral}
    tags*: Tags = {}

    # build
    hexite*: int = 0
    flux*: int = 0
    buildTime*: int = 0
    buildCount*: int = 1

    # stats
    stats*: Stats

    # buildings stuff
    providesSupply*: int = 0


proc `$`*(e: Entity): string =
  result = "Entity: {e.name}\n".fmt
  let facs = e.factions.toSeq.mapIt($it).join(", ")
  result.add "  Factions: {facs}\n".fmt
  let tags = e.tags.toSeq.mapIt($it).join(", ")
  result.add "  Tags: {tags}\n".fmt
  if e.hexite > 0 or e.flux > 0:
    result.add "  Cost: {e.hexite}/{e.flux}".fmt
    if e.buildCount > 1:
      result.add " (for {e.buildCount} units)".fmt
    result.add "\n"
  if e.buildTime > 0:
    result.add "  Build Time: {e.buildTime} sec\n".fmt

  if e.providesSupply > 0:
    result.add "  Provides Supply: {e.providesSupply}\n".fmt

  result.add "  Stats: \n"

  if e.stats.supply > 0:
    result.add "    Supply: {int(e.stats.supply)}\n".fmt

  if e.stats.hp > 0:
    result.add "    HP: {int(e.stats.hp)}\n".fmt

  if e.stats.vision > 0:
    result.add "    Vision: {int(e.stats.vision)}\n".fmt

  if e.stats.speed > 0:
    result.add "    Speed: {int(e.stats.speed)}\n".fmt

  if e.stats.shields > 0:
    result.add "    Shields: {int(e.stats.shields)}\n".fmt

  if e.stats.energy > 0:
    result.add "    Energy: {int(e.stats.energy)}\n".fmt

  if e.stats.damageReduction > 0:
    result.add "    Damage Reduction: {int(e.stats.damageReduction)}\n".fmt

  if e.stats.damage > 0:
    result.add "    Damage: {int(e.stats.damage)}\n".fmt

  if e.stats.attacks > 0:
    result.add "    Attacks: {int(e.stats.attacks)}\n".fmt

  if e.stats.range > 0:
    result.add "    Range: {int(e.stats.range)}\n".fmt

  if e.stats.reload > 0:
    result.add "    Reload: {e.stats.reload} sec\n".fmt

  if e.stats.splash[0] > 0:
    let amt = int(floor(e.stats.splash.amount * 100))
    let rad = e.stats.splash.radius
    result.add "    Splash: {amt}% over {rad}\n".fmt


proc dps*(stats: Stats): float =
  stats.attacks * stats.damage / stats.reload
