type
  Faction* {.pure.} = enum
    Neutral
    Protectorate
    Grell
    Legion
    Xol
    Marran
    DreadRaiders
    Valkaru
    ChaKru

  Tag* {.pure.} = enum
    Unit
    Builder
    Harvester
    Hero
    Attacker
    Grounded
    Flying
    ShootsUp
    ShootsDown
    HasSplash
    Building
    HQ
    Outpost
    Base # both HQ and Outposts are bases
    Supply
    Production
    Tech
    Massive
    T1 = "Tier1"
    T2 = "Tier2"
    T3 = "Tier3"
    LightArmor
    MediumArmor
    HeavyArmor

  Tags* = set[Tag]

  Splash* = tuple[amount, radius: float]
  BonusForTag* = tuple[amount: float, tags: Tags]
