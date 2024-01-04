## A DSL for defining entities

import std/setutils
import std/with

import ./[entity, types]
export types

type
  EntityWrapper* = object
    e: Entity

proc tag(ewrap: var EntityWrapper, arg: set[Tag]) {.inline.} =
  ewrap.e.tags = ewrap.e.tags + arg

proc tag(ewrap: var EntityWrapper, arg: varargs[Tag]) {.inline.} =
  ewrap.tag arg.toSet

proc faction(ewrap: var EntityWrapper, arg: set[Faction]) {.inline.} =
  ewrap.e.factions = ewrap.e.factions + arg

proc faction(ewrap: var EntityWrapper, arg: varargs[Faction]) {.inline.} =
  ewrap.faction arg.toSet

proc cost(ewrap: var EntityWrapper, h: int; f: int = 0) {.inline.} =
  ewrap.e.hexite = h
  ewrap.e.flux = f

proc time(ewrap: var EntityWrapper, t: int) {.inline.} =
  ewrap.e.buildTime = t

proc builds(ewrap: var EntityWrapper, ct: int) {.inline.} =
  ewrap.e.buildCount = ct

proc supply(ewrap: var EntityWrapper, supply: float) {.inline.} =
  ewrap.e.stats.supply = supply

proc hp(ewrap: var EntityWrapper, hp: float) {.inline.} =
  ewrap.e.stats.hp = hp

proc vision(ewrap: var EntityWrapper, vision: float) {.inline.} =
  ewrap.e.stats.vision = vision

proc speed(ewrap: var EntityWrapper, speed: float) {.inline.} =
  ewrap.e.stats.speed = speed

proc shields(ewrap: var EntityWrapper, shields: float) {.inline.} =
  ewrap.e.stats.shields = shields

proc energy(ewrap: var EntityWrapper, energy: float) {.inline.} =
  ewrap.e.stats.energy = energy

proc damageReduction(ewrap: var EntityWrapper,
    damageReduction: float) {.inline.} =
  ewrap.e.stats.damageReduction = damageReduction

proc damage(ewrap: var EntityWrapper, damage: float) {.inline.} =
  ewrap.tag Attacker
  ewrap.e.stats.damage = damage

proc range(ewrap: var EntityWrapper, range: float) {.inline.} =
  ewrap.tag Attacker
  ewrap.e.stats.range = range

proc attacks(ewrap: var EntityWrapper, attacks: float) {.inline.} =
  ewrap.tag Attacker
  ewrap.e.stats.attacks = attacks

proc reload(ewrap: var EntityWrapper, reload: float) {.inline.} =
  ewrap.tag Attacker
  ewrap.e.stats.reload = reload

type ArmorType {.inject.} = enum Light, Medium, Heavy

proc armor(ewrap: var EntityWrapper, t: ArmorType) = ewrap.e.tags.incl case t:
  of Light: LightArmor
  of Medium: MediumArmor
  of Heavy: HeavyArmor

proc bonus(ewrap: var EntityWrapper, amount: float, tag: Tag) {.inline.} =
  ewrap.tag Attacker
  ewrap.e.stats.bonuses.add (amount, {tag})

proc splash(ewrap: var EntityWrapper, amount, radius: float) {.inline.} =
  ewrap.tag Attacker
  ewrap.e.stats.splash = (amount, radius)

proc providesSupply(ewrap: var EntityWrapper, amount: int) {.inline.} =
  ewrap.tag Supply
  ewrap.e.providesSupply = amount

# ---------------

template defineEntity(constName: untyped, body: untyped): untyped =
  let `constName`* = block:
    let name = astToStr(constName)
    var entinner {.inject.} = Entity(name: name)
    var entity {.inject.} = EntityWrapper(e: entinner)

    with entity:
      body

    when isMainModule:
      echo "\n\n---------------------------------------\n"
      echo name, $entinner
      echo "\n---------------------------------------"
      echo "\n\n"

    entinner


template defineUnit*(constName: untyped, body: untyped): untyped =
  defineEntity constName:
    tag Unit
    vision 1800
    body

template defineHero*(constName: untyped, body: untyped): untyped =
  defineEntity constName:
    tag Unit, Hero, Grounded, Attacker
    body

template defineBuilder*(constName: untyped, body: untyped): untyped =
  defineEntity constName:
    tag Unit, Builder
    body

template defineHarvester*(constName: untyped, body: untyped): untyped =
  defineEntity constName:
    tag Unit, Harvester
    body

template defineGroundArmy*(constName: untyped, body: untyped): untyped =
  defineEntity constName:
    tag Unit, Grounded, Attacker
    body

template defineFlyingArmy*(constName: untyped, body: untyped): untyped =
  defineEntity constName:
    tag Unit, Flying, Attacker
    body

template defineBuilding*(constName: untyped, body: untyped): untyped =
  defineEntity constName:
    tag Building
    vision 1500
    body

template defineStaticDefense*(constName: untyped, body: untyped): untyped =
  defineEntity constName:
    tag Building, Attacker
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
  reload 3
  range 2700
