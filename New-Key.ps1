# EN AQUESTA FUNCIÓ ENVIEM LA RUTA ON CREAR EL REGISTRE
# PER REVISAR SI CONTÉ LA RUTA ARREL (HKLM, PER EXEMPLE)
# SI LA RUTA CONTÉ AQUEST VALOR INICIAL RETORNA UN TRUE
# SINO, FALSE. D'AQUESTA MANERA CENTRALITZO LES CONSULTES
function Valor-Conte ($CadenaText, $Valor)
{
    if($CadenaText -like $Valor)
    {
        return 'True'
    }else {
        return 'False'
    }
}
# AQUESTA ES LA FUNCIÓ PRINCIPAL. QUAN REP LA DIRECCIÓ
# DEL REGISTRE QUE ES VOL CREAR, CONSULTA A VALOR-CONTE
# PER SABER SI CONTÉ EL REGISTRE ARREL. SI ESTÀ BÉ, REBEM
# UN TRUE, SINO FALSE.
# QUAN REBEM UN TRUE, CONFIRMEM QUE LA RUTA ENTRANT EX-
# ISTEIX, I ES CREA EL REGISTRE.

# EN CAS QUE LA RUTA ENTRANT NO TINGUI EL REGISTRE
# PARE, SALTA UN ERROR I UNA ADVERTÈNCIA.
# AVISANT QUÈ ÉS NECESSARI ESCRIURE L'ARREL.
# EN CAS QUE LA CARPETA NO EXISTEIXI, SALTA UN
# ERROR I UNA ADVERTÈNCIA.
function New-Key([String]$Direccio, [String]$Nom, [char]$Informacio)
{
    if (((Valor-Conte -CadenaText $Direccio -Valor 'HKCR:\*') -eq 'True') -or ((Valor-Conte -CadenaText $Direccio -Valor 'HKCU:\*') -eq 'True') -or ((Valor-Conte -CadenaText $Direccio -Valor 'HKLM:\*') -eq 'True') -or ((Valor-Conte -CadenaText $Direccio -Valor 'HKU:\*') -eq 'True') -or ((Valor-Conte -CadenaText $Direccio -Valor 'HKCC:\*') -eq 'True')) 
    {
        if (Test-Path -Path $Direccio) {
            try 
            {
                New-Item -Path $Direccio -name $Nom -ErrorAction Stop | Out-Null
            }
            catch
            {
                Write-Error 'ERROR EN CREAR LA CLAU'
                Write-Host "NO S'HA POGUT CREAR LA CLAU, REVISA QUE LA CLAU NO ESTIGUI REPETIDA I-O QUE TINGUIS PERMISSOS PER FER-HO." -ForegroundColor Red -BackgroundColor Black
                Break
            }
            
            if (!($Informacio -eq 'n') -or !$Informacio ) {
                Write-Host "############`n#NOVA CLAU!#`n############`nNOM CLAU: $Nom`nRUTA: $Direccio" -BackgroundColor Green -ForegroundColor Black
            }
            
        }
        else
        {
            Write-Error 'LA RUTA NO EXISTEIX'
            Write-Host 'LA RUTA ESCRITA NO EXISTEIX' -ForegroundColor Red -BackgroundColor Black
        }
    }
    else 
    {
        Write-Error 'LA RUTA ESTÀ MALAMENT'
        if ((Valor-Conte -CadenaText $Direccio -Valor '.\*') -eq 'True') {
            Write-Warning "S'HA D'ESPECIFICAR LA CARPETA ARREL ('HKCR:\', 'HKCU:\', 'HKLM:\', 'HKU:\', o 'HKCC:\'). EL '.\' NO SERVEIX."
        }else {
            Write-Warning "S'HA D'ESPECIFICAR LA CARPETA ARREL ('HKCR:\', 'HKCU:\', 'HKLM:\', 'HKU:\', o 'HKCC:\')."
        }   
    }
}

#LES RUTES PARES HAN DE SER 'HKCR:\', 'HKCU:\', 'HKLM:\', 'HKU:\', o 'HKCC:\'