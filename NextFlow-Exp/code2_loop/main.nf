nextflow.enable.dsl=2

process runFirstScript {
    input:
    tuple (val (iter), path (script1)) 

    output:
    tuple (val(iter), path('output1.txt'))
    
    publishDir "intermediate", mode: 'copy'
    
    script:
    """
    python3 $script1 "${iter}" 
    """
}

process runSecondScript {
    input:
    tuple (val(iter), path(output1), path (script2))

    output:
    path "output2_iter${iter}.txt"

    publishDir "results", mode: 'copy'

    script:
    """
    python3 $script2 $output1 "${iter}" 
    """
}

workflow {
    // Define your scripts as paths or channels
    // Provide the paths directly
    script1 = file('first_script.py')
    script2 = file('second_script.py')

    // Create a channel of iteration values [1, 2, 3, 4, 5]
    iter_ch = Channel.from(1..5)

    // Pair each iteration with script1
    iter_with_script1 = iter_ch.map { i -> tuple(i, script1) }

    // Run the first script
    output1_ch = runFirstScript(iter_with_script1)

    // Pair each iteration result with script2
    pair_ch = output1_ch.map { i, f -> tuple(i, f, script2) }

    // Run the second script
    runSecondScript(pair_ch)
}
