process runPython {
    input:
    path "hello.py"

    output:
    path "hello.txt"

    // Optional: write result to a clean folder
    publishDir "results", mode: 'copy'

    script:
    """
    python3 hello.py
    """
}

workflow {
    script_ch = Channel.fromPath("hello.py")
    runPython(script_ch)
}
