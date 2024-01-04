import ./types

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

  Entity* = object
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

# proc newEntity*(name: string): Entity =
#   result = Entity(name: name)

proc dps*(stats: Stats): float =
  stats.attacks * stats.damage / stats.reload
