<#
$input_files = @(
                ".\params_dir\pv2_rb_ba_1.txt", ".\params_dir\pv2_rb_ba_2.txt", ".\params_dir\pv2_rb_ba_3.txt", ".\params_dir\pv2_rb_ba_4.txt",
                ".\params_dir\pv2_rb_ba_5.txt", ".\params_dir\pv2_rb_ba_6.txt", ".\params_dir\pv2_rb_ba_7.txt", ".\params_dir\pv2_rb_ba_8.txt",
                ".\params_dir\pv2_rb_ba_9.txt", ".\params_dir\pv2_rb_ba_10.txt", ".\params_dir\pv2_rb_ba_11.txt", ".\params_dir\pv2_rb_ba_12.txt",
                ".\params_dir\pv2_rb_ba_13.txt", ".\params_dir\pv2_rb_ba_14.txt", ".\params_dir\pv2_rb_ba_15.txt", ".\params_dir\pv2_rb_ba_16.txt",
                ".\params_dir\pv2_rb_er_1.txt", ".\params_dir\pv2_rb_er_2.txt", ".\params_dir\pv2_rb_er_3.txt", ".\params_dir\pv2_rb_er_4.txt",
                ".\params_dir\pv2_rb_er_5.txt", ".\params_dir\pv2_rb_er_6.txt", ".\params_dir\pv2_rb_er_7.txt", ".\params_dir\pv2_rb_er_8.txt",
                ".\params_dir\pv2_rb_er_9.txt", ".\params_dir\pv2_rb_er_10.txt", ".\params_dir\pv2_rb_er_11.txt", ".\params_dir\pv2_rb_er_12.txt",
                ".\params_dir\pv2_rb_er_13.txt", ".\params_dir\pv2_rb_er_14.txt", ".\params_dir\pv2_rb_er_15.txt", ".\params_dir\pv2_rb_er_16.txt"
)
#>

$input_files = @(
    ".\params_dir\pv2_ifn_b1_email_1.txt", ".\params_dir\pv2_ifn_b1_email_2.txt", ".\params_dir\pv2_ifn_b1_email_3.txt",
    ".\params_dir\pv2_ifn_b1_email_4.txt", ".\params_dir\pv2_ifn_b1_email_5.txt",
    ".\params_dir\pv2_ifn_b07_email_1.txt", ".\params_dir\pv2_ifn_b07_email_2.txt", ".\params_dir\pv2_ifn_b07_email_3.txt",
    ".\params_dir\pv2_ifn_b07_email_4.txt", ".\params_dir\pv2_ifn_b07_email_5.txt",
    ".\params_dir\pv2_ifn_b04_email_1.txt", ".\params_dir\pv2_ifn_b04_email_2.txt", ".\params_dir\pv2_ifn_b04_email_3.txt",
    ".\params_dir\pv2_ifn_b04_email_4.txt", ".\params_dir\pv2_ifn_b04_email_5.txt"
)
<#
$prefix_ba = ".\wyniki_nowe\propv2\rozne_bety\ba\"
$prefix_er = ".\wyniki_nowe\propv2\rozne_bety\er\"
#>

$prefix_b1 = ".\wyniki_nowe\propv2\zaleznosc_od_ilosci_inf\betas1\email\"
$prefix_b07 = ".\wyniki_nowe\propv2\zaleznosc_od_ilosci_inf\betas07\email\"
$prefix_b04 = ".\wyniki_nowe\propv2\zaleznosc_od_ilosci_inf\betas04\email\"

$output_files = @(
    "${prefix_b1}1.txt", "${prefix_b1}2.txt", "${prefix_b1}3.txt",
    "${prefix_b1}4.txt", "${prefix_b1}5.txt",
    "${prefix_b07}1.txt", "${prefix_b07}2.txt", "${prefix_b07}3.txt",
    "${prefix_b07}4.txt", "${prefix_b07}5.txt",
    "${prefix_b04}1.txt", "${prefix_b04}2.txt", "${prefix_b04}3.txt",
    "${prefix_b04}4.txt", "${prefix_b04}5.txt"
)
<#
$output_files = @("${prefix_ba}1_03.txt", "${prefix_ba}1_03_03.txt", "${prefix_ba}1_03_03_03.txt", "${prefix_ba}1_03_03_03_03.txt",
                "${prefix_ba}1_05.txt", "${prefix_ba}1_05_05.txt", "${prefix_ba}1_05_05_05.txt", "${prefix_ba}1_05_05_05_05.txt",
                "${prefix_ba}1_07.txt", "${prefix_ba}1_07_07.txt", "${prefix_ba}1_07_07_07.txt", "${prefix_ba}1_07_07_07_07.txt",
                "${prefix_ba}1_09.txt", "${prefix_ba}1_09_09.txt", "${prefix_ba}1_09_09_09.txt", "${prefix_ba}1_09_09_09_09.txt",
                "${prefix_er}1_03.txt", "${prefix_er}1_03_03.txt", "${prefix_er}1_03_03_03.txt", "${prefix_er}1_03_03_03_03.txt",
                "${prefix_er}1_05.txt", "${prefix_er}1_05_05.txt", "${prefix_er}1_05_05_05.txt", "${prefix_er}1_05_05_05_05.txt",
                "${prefix_er}1_07.txt", "${prefix_er}1_07_07.txt", "${prefix_er}1_07_07_07.txt", "${prefix_er}1_07_07_07_07.txt",
                "${prefix_er}1_09.txt", "${prefix_er}1_09_09.txt", "${prefix_er}1_09_09_09.txt", "${prefix_er}1_09_09_09_09.txt")
#>


for ($i=0; $i -lt $input_files.Length; $i++) {
    Write-Host "julia -t auto src\parallel_main.jl $($input_files[$i]) $($output_files[$i])" 
    Start-Process -NoNewWindow -Wait -FilePath "julia" -ArgumentList @("-t", "auto", "src\parallel_main.jl", $input_files[$i], $output_files[$i])
    Write-Host "Running script: ($($i)/$($input_files.Length))"
}                   