## A DSL for defining entities

import std/setutils

import ./[entity, types]
export types

template setsArg(what, name, prop: untyped, typ: typedesc): untyped =
  proc `name s`(arg: set[typ]) = what.prop = what.prop + arg
  proc `name s`(arg: varargs[typ]) = `name s`(toSet arg)
  proc name(arg: varargs[typ]) = `name s`(toSet arg)

template defineEntity(constName: untyped, body: untyped): untyped =
  const `constName`* = block:
    let name = astToStr(constName)
    var ent = Entity(name: name)

    # disable hints that these procs aren't used
    {.push used.}

    setsArg ent, tag, tags, Tag
    setsArg ent, faction, factions, Faction

    proc cost(h: int; f: int = 0) =
      ent.hexite = h
      ent.flux = f

    proc time(t: int) =
      ent.buildTime = t

    proc builds(ct: int) =
      ent.buildCount = ct

    proc supply(supply: float) =
      ent.stats.supply = supply

    proc hp(hp: float) =
      ent.stats.hp = hp

    proc vision(vision: float) =
      ent.stats.vision = vision

    proc speed(speed: float) =
      ent.stats.speed = speed

    proc shields(shields: float) =
      ent.stats.shields = shields

    proc energy(energy: float) =
      ent.stats.energy = energy

    proc damageReduction(damageReduction: float) =
      ent.stats.damageReduction = damageReduction

    proc damage(damage: float) =
      tags Attacker
      ent.stats.damage = damage

    proc range(range: float) =
      tags Attacker
      ent.stats.range = range

    proc attacks(attacks: float) =
      tags Attacker
      ent.stats.attacks = attacks

    proc reload(reload: float) =
      tags Attacker
      ent.stats.reload = reload

    type ArmorType {.inject.} = enum Light, Medium, Heavy

    proc armor(t: ArmorType) = ent.tags.incl case t:
      of Light: LightArmor
      of Medium: MediumArmor
      of Heavy: HeavyArmor

    proc bonus(amount: float, tag: Tag) =
      tags Attacker
      ent.stats.bonuses.add (amount, {tag})

    proc splash(amount, radius: float) =
      tags Attacker
      ent.stats.splash = (amount, radius)

    proc providesSupply(amount: int) =
      tags Supply
      ent.providesSupply = amount

    {.pop.}


    body

    when isMainModule:
      echo "\n\n---------------------------------------\n"
      echo name, ent
      echo "\n---------------------------------------"
      echo "\n\n"

    ent


template defineUnit*(constName: untyped, body: untyped): untyped =
  defineEntity constName:
    tags Unit
    vision 1800
    body

template defineHero*(constName: untyped, body: untyped): untyped =
  defineEntity constName:
    tags Unit, Hero, Grounded, Attacker
    body

template defineBuilder*(constName: untyped, body: untyped): untyped =
  defineEntity constName:
    tags Unit, Builder
    body

template defineHarvester*(constName: untyped, body: untyped): untyped =
  defineEntity constName:
    tags Unit, Harvester
    body

template defineGroundArmy*(constName: untyped, body: untyped): untyped =
  defineEntity constName:
    tags Unit, Grounded, Attacker
    body

template defineFlyingArmy*(constName: untyped, body: untyped): untyped =
  defineEntity constName:
    tags Unit, Flying, Attacker
    body

template defineBuilding*(constName: untyped, body: untyped): untyped =
  defineEntity constName:
    tags Building
    vision 1500
    body

template defineStaticDefense*(constName: untyped, body: untyped): untyped =
  defineEntity constName:
    tags Building, Attacker
    vision 1500
    body

defineGroundArmy Stinger:
  faction Grell
  cost 50
  time 18
  builds 2
  supply 1
  hp 100
  armor Light
  speed 700
  vision 1800
  damage 5
  reload 0.6
  range 100

defineGroundArmy Thresher:
  faction Grell
  cost 100, 200
  time 60
  supply 8
  hp 625
  armor Heavy
  speed 450
  vision 1800
  damage 110
  bonus 0.5, Building
  splash 0.5, 60
  reload 2.15
  range 2700
