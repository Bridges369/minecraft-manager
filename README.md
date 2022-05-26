# Minecraft Manager

A command-line program to manange backups of worlds, behaviors packs and resource packs, and create scope of behaviors and resources; all locally.

# Waring!
**This program works only Bedrock Edition now. The Java Edition will be suported in future updates.**

----------------------------

# Commands

## run

Run executable of your Minecraft.

**SYNTAX**

```
mcm {b[edrock] | j[ava]} run
```

---

## backup

This command makes backups of your worlds and packages to a local directory.

**SYNTAX**

```
mcm {b[edrock] | j[ava]} backup {worlds | packs {resource | behavior}}
```

**EXAMPLES**
```
# create backup of all Bedrock worlds
mcm b backup wolrds
```
```
# create backup of java resource packs
mcm j packs resource
```

---

## restore

Restore all backups made.

**SYNTAX**

```
mcm {b[edrock] | j[ava]} restore {worlds | packs {resource | behavior}}
```

**EXAMPLES**

```
# recover all java worlds
mcm java restore worlds
```
```
# recover all Bedrock behaviors packs
mcm bedrock restore packs behavior
```

---

## listBackups

List all backups made.

**SYNTAX**

```
mcm {b[edrock] | j[ava]} listBackups {worlds | packs <resource | behavior}}
```

**EXAMPLES**

```
# list backups of Bedrock worlds
mcm b listBackups worlds
```
```
# listBackups of Bedrock resource packs
mcm bedrock listBackups packs resource
```

---

## returnRestore

Return to before restore.

**SYNTAX**

```
cmd {b[edrock] | j[ava]} returnRestore {worlds | packs {resource | behavior}}
```

**EXAMPLES**

```
# return to before Bedrock worlds
mcm b returnRestore worlds
```

<!-- ## create -->
