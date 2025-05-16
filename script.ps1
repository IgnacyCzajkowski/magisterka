
$input_files = @(
    ".\params_dir_new\pv2_bm1_bn03_email.txt", ".\params_dir_new\pv2_bm1_bn05_email.txt",
    ".\params_dir_new\pv2_bm1_bn07_email.txt", ".\params_dir_new\pv2_bm1_bn09_email.txt",
    ".\params_dir_new\pv2_bm08_bn03_email.txt", ".\params_dir_new\pv2_bm08_bn05_email.txt",
    ".\params_dir_new\pv2_bm08_bn07_email.txt", ".\params_dir_new\pv2_bm08_bn09_email.txt",
    ".\params_dir_new\pv2_bm06_bn03_email.txt", ".\params_dir_new\pv2_bm06_bn05_email.txt",
    ".\params_dir_new\pv2_bm06_bn07_email.txt", ".\params_dir_new\pv2_bm06_bn09_email.txt",
    ".\params_dir_new\pv2_bm04_bn03_email.txt", ".\params_dir_new\pv2_bm04_bn05_email.txt",
    ".\params_dir_new\pv2_bm04_bn07_email.txt", ".\params_dir_new\pv2_bm04_bn09_email.txt",

    ".\params_dir_new\pv2_bm1_bn03_infectious.txt", ".\params_dir_new\pv2_bm1_bn05_infectious.txt",
    ".\params_dir_new\pv2_bm1_bn07_infectious.txt", ".\params_dir_new\pv2_bm1_bn09_infectious.txt",
    ".\params_dir_new\pv2_bm08_bn03_infectious.txt", ".\params_dir_new\pv2_bm08_bn05_infectious.txt",
    ".\params_dir_new\pv2_bm08_bn07_infectious.txt", ".\params_dir_new\pv2_bm08_bn09_infectious.txt",
    ".\params_dir_new\pv2_bm06_bn03_infectious.txt", ".\params_dir_new\pv2_bm06_bn05_infectious.txt",
    ".\params_dir_new\pv2_bm06_bn07_infectious.txt", ".\params_dir_new\pv2_bm06_bn09_infectious.txt",
    ".\params_dir_new\pv2_bm04_bn03_infectious.txt", ".\params_dir_new\pv2_bm04_bn05_infectious.txt",
    ".\params_dir_new\pv2_bm04_bn07_infectious.txt", ".\params_dir_new\pv2_bm04_bn09_infectious.txt",

    ".\params_dir_new\pv2_bm1_bn03_ucirving.txt", ".\params_dir_new\pv2_bm1_bn05_ucirving.txt",
    ".\params_dir_new\pv2_bm1_bn07_ucirving.txt", ".\params_dir_new\pv2_bm1_bn09_ucirving.txt",
    ".\params_dir_new\pv2_bm08_bn03_ucirving.txt", ".\params_dir_new\pv2_bm08_bn05_ucirving.txt",
    ".\params_dir_new\pv2_bm08_bn07_ucirving.txt", ".\params_dir_new\pv2_bm08_bn09_ucirving.txt",
    ".\params_dir_new\pv2_bm06_bn03_ucirving.txt", ".\params_dir_new\pv2_bm06_bn05_ucirving.txt",
    ".\params_dir_new\pv2_bm06_bn07_ucirving.txt", ".\params_dir_new\pv2_bm06_bn09_ucirving.txt",
    ".\params_dir_new\pv2_bm04_bn03_ucirving.txt", ".\params_dir_new\pv2_bm04_bn05_ucirving.txt",
    ".\params_dir_new\pv2_bm04_bn07_ucirving.txt", ".\params_dir_new\pv2_bm04_bn09_ucirving.txt"
)

<#
$prefix_ba = ".\wyniki_nowe\propv2\rozne_bety\ba\"
$prefix_er = ".\wyniki_nowe\propv2\rozne_bety\er\"
#>

$prefix_email = ".\wyniki_nowe\propv2\rozne_bety\email\"
$prefix_infectious = ".\wyniki_nowe\propv2\rozne_bety\infectious\"
$prefix_ucirving = ".\wyniki_nowe\propv2\rozne_bety\ucirving\"
   
$output_files = @(
                "${prefix_email}1_03_03_03_03.txt", "${prefix_email}1_05_05_05_05.txt",
                "${prefix_email}1_07_07_07_07.txt", "${prefix_email}1_09_09_09_09.txt",
                "${prefix_email}08_03_03_03_03.txt", "${prefix_email}08_05_05_05_05.txt",
                "${prefix_email}08_07_07_07_07.txt", "${prefix_email}08_09_09_09_09.txt",
                "${prefix_email}06_03_03_03_03.txt", "${prefix_email}06_05_05_05_05.txt",
                "${prefix_email}06_07_07_07_07.txt", "${prefix_email}06_09_09_09_09.txt",
                "${prefix_email}04_03_03_03_03.txt", "${prefix_email}04_05_05_05_05.txt",
                "${prefix_email}04_07_07_07_07.txt", "${prefix_email}04_09_09_09_09.txt",

                "${prefix_infectious}1_03_03_03_03.txt", "${prefix_infectious}1_05_05_05_05.txt",
                "${prefix_infectious}1_07_07_07_07.txt", "${prefix_infectious}1_09_09_09_09.txt",
                "${prefix_infectious}08_03_03_03_03.txt", "${prefix_infectious}08_05_05_05_05.txt",
                "${prefix_infectious}08_07_07_07_07.txt", "${prefix_infectious}08_09_09_09_09.txt",
                "${prefix_infectious}06_03_03_03_03.txt", "${prefix_infectious}06_05_05_05_05.txt",
                "${prefix_infectious}06_07_07_07_07.txt", "${prefix_infectious}06_09_09_09_09.txt",
                "${prefix_infectious}04_03_03_03_03.txt", "${prefix_infectious}04_05_05_05_05.txt",
                "${prefix_infectious}04_07_07_07_07.txt", "${prefix_infectious}04_09_09_09_09.txt",

                "${prefix_ucirving}1_03_03_03_03.txt", "${prefix_ucirving}1_05_05_05_05.txt",
                "${prefix_ucirving}1_07_07_07_07.txt", "${prefix_ucirving}1_09_09_09_09.txt",
                "${prefix_ucirving}08_03_03_03_03.txt", "${prefix_ucirving}08_05_05_05_05.txt",
                "${prefix_ucirving}08_07_07_07_07.txt", "${prefix_ucirving}08_09_09_09_09.txt",
                "${prefix_ucirving}06_03_03_03_03.txt", "${prefix_ucirving}06_05_05_05_05.txt",
                "${prefix_ucirving}06_07_07_07_07.txt", "${prefix_ucirving}06_09_09_09_09.txt",
                "${prefix_ucirving}04_03_03_03_03.txt", "${prefix_ucirving}04_05_05_05_05.txt",
                "${prefix_ucirving}04_07_07_07_07.txt", "${prefix_ucirving}04_09_09_09_09.txt"
                
                )



for ($i=0; $i -lt $input_files.Length; $i++) {
    Write-Host "julia -t auto src\parallel_main.jl $($input_files[$i]) $($output_files[$i])" 
    Start-Process -NoNewWindow -Wait -FilePath "julia" -ArgumentList @("-t", "auto", "src\parallel_main.jl", $input_files[$i], $output_files[$i])
    Write-Host "Running script: ($($i)/$($input_files.Length))"
}                   