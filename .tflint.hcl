# .tflint.hcl
config {
  module = true
}

# include externo
# TFLint no tiene "include" nativo; por eso usaremos --config en el hook.
# Dejamos este archivo mínimo por si ejecutas tflint a mano en la raíz.
