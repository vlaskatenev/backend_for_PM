# $global:programm = (@{
#     procName="chrome"
#     ProgrammName="Google Chrome"
#     procDescription="Browser"
# }, @{
#     procName="chrome2"
#     ProgrammName="Google Chrome2"
#     procDescription="Browser2"
# })

$allProgramm = (@{
        procName="chrome"
        ProgrammName="Google Chrome"
        procDescription="Browser"
    }, @{
        procName="chrome2"
        ProgrammName="Google Chrome2"
        procDescription="Browser2"
    })

Export-ModuleMember -Variable allProgramm
