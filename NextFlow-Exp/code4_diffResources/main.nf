nextflow.enable.dsl=2

process runFirstScript {
    label 'light_job'

    input:
    path script1

    output:
    path 'output1.txt' 

    publishDir "results", mode: 'copy'

    script:
    """
    python3 $script1 
    """
}

process runSecondScript {
    label 'heavy_job'
    input:
    tuple path(script2), path(output1)

    output:
    path 'output2.txt'

    publishDir "results", mode: 'copy'

    script:
    """
    python3 $script2 $output1 
    """
}

workflow {
    // Define your scripts as paths or channels
    script1_ch = channel.fromPath('first_script.py')
    script2_ch = channel.fromPath('second_script.py')

    // Run the first script
    output1_ch = runFirstScript(script1_ch)

    // Combine second_script and output from first
    pair_ch = script2_ch.combine(output1_ch)

    // Run the second script
    runSecondScript(pair_ch)
}
