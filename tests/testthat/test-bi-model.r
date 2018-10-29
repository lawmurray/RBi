context("Testing bi_model manipulation")

model_file_name <- system.file(package="rbi", "PZ.bi")
PZ <- bi_model(filename = model_file_name)

test_that("models can be created",
{
  expect_true(length(PZ[]) > 0)
})

test_that("empty models can be created",
{
  expect_true(is_empty(bi_model()))
})

test_that("parameters can be fixed",
{
  expect_true(length(fix(PZ, alpha=0, dummy=1)) > 0)
})

test_that("lines can be inserted",
{
  expect_true(!is_empty(insert_lines(PZ, lines = "noise beta", after = 0)))
  expect_true(!is_empty(insert_lines(PZ, lines = "noise beta", after = 32)))
  expect_true(!is_empty(insert_lines(PZ, lines = "noise beta", before = 9)))
  expect_true(!is_empty(insert_lines(PZ, lines = "beta ~ normal()", at_beginning_of = "transition")))
  expect_true(!is_empty(insert_lines(PZ, lines = "beta ~ normal()", before = "dummy")))
  expect_true(!is_empty(insert_lines(PZ, lines = "beta ~ normal()", after = "parameter")))
  expect_error(insert_lines(PZ, lines = "noise beta"))
  expect_error(insert_lines(PZ, lines = "noise beta", after=35))
})

test_that("lines can be removed",
{
  expect_true(length(remove_lines(PZ, "parameter", only="sigma")[]) > 0)
  expect_true(length(remove_lines(PZ, 14)[]) > 0)
  expect_error(remove_lines(PZ))
  expect_error(remove_lines(PZ, list()))
})

test_that("strings can be replaced",
{
  expect_true(length(replace_all(PZ, "sigma", "lambda")[]) > 0)
})

test_that("models can be written to file",
{
  filename <- tempfile()
  write_model(PZ, filename)
  PZ <- bi_model(paste0(filename, ".bi"))
  expect_true(!is_empty(PZ))
})

test_that("model names can be set",
{
  expect_true(length(set_name(PZ, "new_PZ")[]) > 0)
})

test_that("models can be printed",
{
  expect_output(print(PZ), "model PZ")
})

test_that("parts of a model can be extracted",
{
  expect_true(length(PZ[3:4]) == 2)
  PZ[3:4] <- c("const e = 0.4", "const m_l = 0.05")
  expect_true(length(PZ[]) > 0)
})

test_that("blocks operations work",
{
  param_block <- find_block(PZ, "parameter")
  expect_equal(PZ[param_block[-c(1, length(param_block))]],
               get_block(PZ, "parameter"))
  expect_equal(get_block(add_block(PZ, "observation", "dummy"),
                         "observation"),
               "dummy")
  expect_equal(length(get_block(add_block(PZ, "dummy"), "dummy")), 0)
})

