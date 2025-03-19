$input_files = @(".\params_dir\pv1_ifn_b1_ba_1.txt", ".\params_dir\pv1_ifn_b1_ba_2.txt", ".\params_dir\pv1_ifn_b1_ba_3.txt",
                ".\params_dir\pv1_ifn_b1_ba_4.txt", ".\params_dir\pv1_ifn_b1_ba_5.txt", ".\params_dir\pv1_ifn_b1_ba_8.txt",
                ".\params_dir\pv1_ifn_b1_ba_10.txt", ".\params_dir\pv1_ifn_b1_ba_20.txt",
                ".\params_dir\pv1_ifn_b1_er_1.txt", ".\params_dir\pv1_ifn_b1_er_2.txt", ".\params_dir\pv1_ifn_b1_er_3.txt",
                ".\params_dir\pv1_ifn_b1_er_4.txt", ".\params_dir\pv1_ifn_b1_er_5.txt", ".\params_dir\pv1_ifn_b1_er_8.txt",
                ".\params_dir\pv1_ifn_b1_er_10.txt", ".\params_dir\pv1_ifn_b1_er_20.txt",
                ".\params_dir\pv1_ifn_b07_ba_1.txt", ".\params_dir\pv1_ifn_b07_ba_2.txt", ".\params_dir\pv1_ifn_b07_ba_3.txt",
                ".\params_dir\pv1_ifn_b07_ba_4.txt", ".\params_dir\pv1_ifn_b07_ba_5.txt", ".\params_dir\pv1_ifn_b07_ba_8.txt",
                ".\params_dir\pv1_ifn_b07_ba_10.txt", ".\params_dir\pv1_ifn_b07_ba_20.txt",
                ".\params_dir\pv1_ifn_b07_er_1.txt", ".\params_dir\pv1_ifn_b07_er_2.txt", ".\params_dir\pv1_ifn_b07_er_3.txt",
                ".\params_dir\pv1_ifn_b07_er_4.txt", ".\params_dir\pv1_ifn_b07_er_5.txt", ".\params_dir\pv1_ifn_b07_er_8.txt",
                ".\params_dir\pv1_ifn_b07_er_10.txt", ".\params_dir\pv1_ifn_b07_er_20.txt",
                ".\params_dir\pv1_ifn_b04_ba_1.txt", ".\params_dir\pv1_ifn_b04_ba_2.txt", ".\params_dir\pv1_ifn_b04_ba_3.txt",
                ".\params_dir\pv1_ifn_b04_ba_4.txt", ".\params_dir\pv1_ifn_b04_ba_5.txt", ".\params_dir\pv1_ifn_b04_ba_8.txt",
                ".\params_dir\pv1_ifn_b04_ba_10.txt", ".\params_dir\pv1_ifn_b04_ba_20.txt",
                ".\params_dir\pv1_ifn_b04_er_1.txt", ".\params_dir\pv1_ifn_b04_er_2.txt", ".\params_dir\pv1_ifn_b04_er_3.txt",
                ".\params_dir\pv1_ifn_b04_er_4.txt", ".\params_dir\pv1_ifn_b04_er_5.txt", ".\params_dir\pv1_ifn_b04_er_8.txt",
                ".\params_dir\pv1_ifn_b04_er_10.txt", ".\params_dir\pv1_ifn_b04_er_20.txt")

$prefix = ".\wyniki_nowe\propv1\zaleznosc_od_ilosci_inf\"

$output_files = @(
    "${prefix}betas1\ba\1.txt", "${prefix}betas1\ba\2.txt", "${prefix}betas1\ba\3.txt", "${prefix}betas1\ba\4.txt",
    "${prefix}betas1\ba\5.txt", "${prefix}betas1\ba\8.txt", "${prefix}betas1\ba\10.txt", "${prefix}betas1\ba\20.txt",
    "${prefix}betas1\er\1.txt", "${prefix}betas1\er\2.txt", "${prefix}betas1\er\3.txt", "${prefix}betas1\er\4.txt",
    "${prefix}betas1\er\5.txt", "${prefix}betas1\er\8.txt", "${prefix}betas1\er\10.txt", "${prefix}betas1\er\20.txt",
    "${prefix}betas07\ba\1.txt", "${prefix}betas07\ba\2.txt", "${prefix}betas07\ba\3.txt", "${prefix}betas07\ba\4.txt",
    "${prefix}betas07\ba\5.txt", "${prefix}betas07\ba\8.txt", "${prefix}betas07\ba\10.txt", "${prefix}betas07\ba\20.txt",
    "${prefix}betas07\er\1.txt", "${prefix}betas07\er\2.txt", "${prefix}betas07\er\3.txt", "${prefix}betas07\er\4.txt",
    "${prefix}betas07\er\5.txt", "${prefix}betas07\er\8.txt", "${prefix}betas07\er\10.txt", "${prefix}betas07\er\20.txt",
    "${prefix}betas04\ba\1.txt", "${prefix}betas04\ba\2.txt", "${prefix}betas04\ba\3.txt", "${prefix}betas04\ba\4.txt",
    "${prefix}betas04\ba\5.txt", "${prefix}betas04\ba\8.txt", "${prefix}betas04\ba\10.txt", "${prefix}betas04\ba\20.txt",
    "${prefix}betas04\er\1.txt", "${prefix}betas04\er\2.txt", "${prefix}betas04\er\3.txt", "${prefix}betas04\er\4.txt",
    "${prefix}betas04\er\5.txt", "${prefix}betas04\er\8.txt", "${prefix}betas04\er\10.txt", "${prefix}betas04\er\20.txt"
)
<#
$output_files = @($prefix + "1_03.txt", $prefix + "1_03_03.txt", $prefix + "1_03_03_03.txt", $prefix + "1_03_03_03_03.txt",
                $prefix + "1_05.txt", $prefix + "1_05_05.txt", $prefix + "1_05_05_05.txt", $prefix + "1_05_05_05_05.txt",
                $prefix + "1_07.txt", $prefix + "1_07_07.txt", $prefix + "1_07_07_07.txt", $prefix + "1_07_07_07_07.txt",
                $prefix + "1_09.txt", $prefix + "1_09_09.txt", $prefix + "1_09_09_09.txt", $prefix + "1_09_09_09_09.txt")
#>
for ($i=0; $i -lt $input_files.Length; $i++) {
    Write-Host "julia -t auto src\parallel_main.jl $($input_files[$i]) $($output_files[$i])" 
    Start-Process -NoNewWindow -Wait -FilePath "julia" -ArgumentList @("-t", "auto", "src\parallel_main.jl", $input_files[$i], $output_files[$i])
    Write-Host "Running script: ($($i)/$($input_files.Length))"
}                   