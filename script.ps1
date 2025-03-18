$input_files = @(".\params_dir\pv1_rb_er_1.txt", ".\params_dir\pv1_rb_er_2.txt", ".\params_dir\pv1_rb_er_3.txt", ".\params_dir\pv1_rb_er_4.txt",
                ".\params_dir\pv1_rb_er_5.txt", ".\params_dir\pv1_rb_er_6.txt", ".\params_dir\pv1_rb_er_7.txt", ".\params_dir\pv1_rb_er_8.txt",
                ".\params_dir\pv1_rb_er_9.txt", ".\params_dir\pv1_rb_er_10.txt", ".\params_dir\pv1_rb_er_11.txt", ".\params_dir\pv1_rb_er_12.txt",
                ".\params_dir\pv1_rb_er_13.txt", ".\params_dir\pv1_rb_er_14.txt", ".\params_dir\pv1_rb_er_15.txt", ".\params_dir\pv1_rb_er_16.txt")

$prefix = ".\wyniki_nowe\propv1\rozne_bety\er\"

$output_files = @(
    "${prefix}1_03.txt", "${prefix}1_03_03.txt", "${prefix}1_03_03_03.txt", "${prefix}1_03_03_03_03.txt",
    "${prefix}1_05.txt", "${prefix}1_05_05.txt", "${prefix}1_05_05_05.txt", "${prefix}1_05_05_05_05.txt",
    "${prefix}1_07.txt", "${prefix}1_07_07.txt", "${prefix}1_07_07_07.txt", "${prefix}1_07_07_07_07.txt",
    "${prefix}1_09.txt", "${prefix}1_09_09.txt", "${prefix}1_09_09_09.txt", "${prefix}1_09_09_09_09.txt"
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