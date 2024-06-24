                </div>
                </div>
                </div>
                </div>
                <!-- Fin contenido -->

                <div class="row-no-gutters" id="footer">
                    <div class="col-12">
                        <div class="container">
                            <div class="footer-start">
                                <div class="row">
                                    <div class="col-12 text-center">
                                        <span>
                                            JOSE SARMIENTO
                                        </span>
                                    </div>
                                </div>
                                
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Scripts -->

                <script src="./includes/jquery-3.4.1/jquery-3.4.1.min.js"></script>
                <script src="./includes/bootstrap-4.1.3/js/bootstrap.min.js"></script>
                <script src="./includes/ckeditor5/ckeditor.js"></script>


                <script>
                    if (document.querySelector('#editor')) {
                        ClassicEditor
                            .create(document.querySelector('#editor'), {
                                codeBlock: {
                                    languages: [{
                                            language: 'plaintext',
                                            label: 'Plain text'
                                        }, // The default language.
                                        {
                                            language: 'c',
                                            label: 'C'
                                        },
                                        {
                                            language: 'cs',
                                            label: 'C#'
                                        },
                                        {
                                            language: 'cpp',
                                            label: 'C++'
                                        },
                                        {
                                            language: 'css',
                                            label: 'CSS'
                                        },
                                        {
                                            language: 'diff',
                                            label: 'Diff'
                                        },
                                        {
                                            language: 'xml',
                                            label: 'HTML/XML'
                                        },
                                        {
                                            language: 'java',
                                            label: 'Java'
                                        },
                                        {
                                            language: 'javascript',
                                            label: 'JavaScript'
                                        },
                                        {
                                            language: 'php',
                                            label: 'PHP'
                                        },
                                        {
                                            language: 'python',
                                            label: 'Python'
                                        },
                                        {
                                            language: 'ruby',
                                            label: 'Ruby'
                                        },
                                        {
                                            language: 'typescript',
                                            label: 'TypeScript'
                                        }
                                    ]
                                }

                            })
                            .catch(error => {
                                console.error(error);
                            });
                    }
                </script>

                </body>

                </html>