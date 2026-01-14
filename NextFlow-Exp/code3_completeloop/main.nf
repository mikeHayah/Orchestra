nextflow.enable.dsl=2

params.iter = 1
params.prev_output = 'empty.txt' 

process runFirstScript {
    input:
    tuple (val (iter), path (prev_output), path (script1))

    output:
    tuple (val(iter), path('output1.txt'))
 
    publishDir "intermediate", mode: 'copy'

    script:
    """
    python3 $script1 $prev_output "$iter" 
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
    python3 $script2 $output1 "$iter" 
    """
}

workflow {
    script1 = file("first_script.py")
    script2 = file("second_script.py")

    // first = runFirstScript(params.iter, params.prev_output, script1)
    // runSecondScript(params.iter, first.out, script2)

    // Pair each iteration with script1
    iter_with_script1 = Channel.of(tuple(params.iter, file(params.prev_output), script1))

    // Run the first script
    output1_ch = runFirstScript(iter_with_script1)

    // Pair each iteration result with script2
    pair_ch = output1_ch.map { i, f -> tuple(i, f, script2) }

    // Run the second script
    runSecondScript(pair_ch)

}
