<#
.NOTES
..CONFIRMATION
; href => https://stackoverflow.com/questions/24649019/how-to-use-confirm-in-powershell
$title    = 'something'
$question = 'Are you sure you want to proceed?'
$choices  = '&Yes', '&No'

$decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
if ($decision -eq 0) {
    Write-Host 'confirmed'
} else {
    Write-Host 'cancelled'
}
#>


param(
  [Parameter(Mandatory=$False, Position=0, ValueFromPipeline=$False)]
  [System.String]$Edition="bedrock",
  # [bedrock, java]

  [Parameter(Mandatory=$False, Position=1, ValueFromPipeline=$False)]
  [System.String]$Action="run",
  # [run, backup, restore, listBackups, create]

  [Parameter(Mandatory=$False, Position=2, ValueFromPipeline=$False)]
  [System.String]$Type="world",
  <#
    <<1[1..2][world, pack]
    <<1[3][--d]
    <<1[4][resource, behavior]
  #>

  [Parameter(Mandatory=$False, Position=3, ValueFromPipeline=$False)]
  [System.String]$Pack=""
  <#
    <<1[1][resource, behavior]
  #>
)






if($Edition -match "b(edrock)?"){
  $Paths=@{
      worldsBackups="$env:USERPROFILE\Programs\mine\backups\bedrock\worlds";
      worldsRestore="$env:USERPROFILE\Programs\mine\restore\bedrock\worlds";
      packsBackups="$env:USERPROFILE\Programs\mine\backups\bedrock\packs";
      packsRestore="$env:USERPROFILE\Programs\mine\restore\bedrock\packs";
      #-----------------------#
      worlds="$env:APPDATA\..\Local\Packages\Microsoft.MinecraftUWP_8wekyb3d8bbwe\LocalState\games\com.mojang\minecraftWorlds";
      packs=@{
        resource="$env:APPDATA\..\Local\Packages\Microsoft.MinecraftUWP_8wekyb3d8bbwe\LocalState\games\com.mojang\development_resource_packs";
        behavior="$env:APPDATA\..\Local\Packages\Microsoft.MinecraftUWP_8wekyb3d8bbwe\LocalState\games\com.mojang\development_behavior_packs"
      };
      #-----------------------#
      exeutable="C:\Program Files\WindowsApps\Microsoft.MinecraftUWP_1.18.2023.0_x64__8wekyb3d8bbwe\Minecraft.Windows.exe"
    }
}elseif($Edition -match "j(ava)?"){
  $Paths=@{
      worldsBackups="";
      worldsRestore="";
      packsBackups="";
      packsRestore="";
      #-----------------------#
      worlds="";
      packs=@{
        resource="";
        behavior=""
      };
      #-----------------------#
      exe=""
    }
}else{
  Write-Error "Unknown Edition: '$Edition'"
}



function actionCreate {

  param(
    [System.String]$o_type
  )

  switch ( $Action ){
    # .DESCRIPTION: create a new backup for minecraft world or for resources and behaviors packs.
    # .SINTAX:
    # > mine [b, j] backup worlds
    # > mine [b, j] backup packs [resource, behavior]
    # .STATUS: create for the wolrds and packs; wait for atualizations.

    "backup"{
      Copy-Item -Path "$(if($Pack -eq `"`"){$Paths[$o_type]}else{$Paths[$o_type][$Pack]})\*" -Destination $Paths[$o_type+"Backups"] -Force -Recurse
    }


    # .DESCRIPTION: restore backups.
    # .SINTAX:
    # > mine (b, j) restore worlds
    # > mine (b, j) restore packs (resource, behavior)
    # .STATUS: create for the worlds; waiting to create for packages.

    "restore"{
      $ans = $Host.UI.PromptForChoice(
        "$([char]27)[38;2;255;255;0m" + "=== Waring!! ===" + "$([char]27)[0m",
        "$([char]27)[38;2;255;255;0m" + "#>$([char]27)[0m " + "$([char]27)[4;1m" + "Are you sure you want to execute this action?" + "$([char]27)[0m",
        ('&Yes','&No'),
        1
      )
      if($ans -eq 0){
        # secure backup
        Copy-Item -Path "$(
          if($Pack -eq `"`"){
            $Paths[$o_type]}else{$Paths[$o_type][$Pack]}
          <#fonte -> internal#>
        )\*" -Destination $Paths[$o_type+"Restore"] -Force -Recurse

        #restore
        Copy-Item -Path "$($Paths[$o_type+"Backups"])\*" -Destination "$(
          if($Pack -eq `"`"){
            $Paths[$o_type]}else{$Paths[$o_type][$Pack]}
          <#fonte -> internal#>
        )\*" -Force -Recurse
      }else{
        break
      }
    }


    # .DESCRIPTION: list all world from backup.
    # .SINTAX:
    # > mine (b, j) listBackups worlds
    # > mine (b, j) listBackups packs (resource, behavior)
    # .STATUS:

    "listBackups"{
      $h=@{}
      Get-ChildItem $Paths["backups"] | ForEach {
        $h.Add($_.name, (Get-Content "$($Paths["backups"])\$($_.name)\levelname.txt"))
      }
      $h
    }


    # .DESCRIPTION: remove the effects of the last restore
    # .SINTAX:
    # > mine (b, j) returnRestore worlds
    # > mine (b, j) returnRestore packs (resource, behavior)
    # .STATUS:

    "returnRestore"{
      Copy-Item -Path "$($Paths["restore"])\*" -Destination $Paths["worlds"] -Force -Recurse
    }


    # .DESCRIPTION: create a resource or behavior pack
    # .SINTAX:
    # > mine (b, j) create (resource, behavior)
    # .STATUS:
    "create"{
      #
    }
    default { Write-Error "Unknown Action: '$Action'" }
  }
}

<#

#>


switch ( $Action ){
  # > mine [b, j] run
  "run" { start $Paths["executable"] }

  default {
    switch ( $Type ){
      "worlds" {
        actionCreate $Type
      }
      "packs" {
        actionCreate $Type
      }
      default {  }
    }
  }
}
