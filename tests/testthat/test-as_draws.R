test_that("transformations to and from draws_matrix objects work", {
  draws_matrix <- as_draws_matrix(example_draws())

  draws_array <- as_draws_array(draws_matrix)
  draws_matrix2 <- as_draws_matrix(draws_array)
  expect_equal(draws_matrix, draws_matrix2)

  draws_df <- as_draws_df(draws_matrix)
  draws_matrix2 <- as_draws_matrix(draws_df)
  expect_equal(draws_matrix, draws_matrix2)

  draws_list <- as_draws_list(draws_matrix)
  draws_matrix2 <- as_draws_matrix(draws_list)
  expect_equal(draws_matrix, draws_matrix2)
})

test_that("transformations to and from draws_array objects work", {
  draws_array <- as_draws_array(example_draws())

  draws_matrix <- as_draws_matrix(draws_array)
  draws_array2 <- as_draws_array(draws_matrix)
  # cannot check equality as draws_matrix objects loose chain information
  expect_equal(
    summarise_draws(draws_array, default_summary_measures()),
    summarise_draws(draws_array2, default_summary_measures())
  )

  draws_df <- as_draws_df(draws_array)
  draws_array2 <- as_draws_array(draws_df)
  expect_equal(draws_array, draws_array2)

  draws_list <- as_draws_list(draws_array)
  draws_array2 <- as_draws_array(draws_list)
  expect_equal(draws_array, draws_array2)
})

test_that("transformations to and from draws_df objects work", {
  draws_df <- as_draws_df(example_draws())

  draws_matrix <- as_draws_matrix(draws_df)
  draws_df2 <- as_draws_df(draws_matrix)
  # cannot check equality as draws_matrix objects loose chain information
  expect_equal(
    summarise_draws(draws_df, default_summary_measures()),
    summarise_draws(draws_df2, default_summary_measures())
  )

  draws_array <- as_draws_array(draws_df)
  draws_df2 <- as_draws_df(draws_array)
  expect_equal(draws_df, draws_df2)

  draws_list <- as_draws_list(draws_df)
  draws_df2 <- as_draws_df(draws_list)
  expect_equal(draws_df, draws_df2)
})

test_that("transformations to and from draws_list objects work", {
  draws_list <- as_draws_list(example_draws())

  draws_matrix <- as_draws_matrix(draws_list)
  draws_list2 <- as_draws_list(draws_matrix)
  # cannot check equality as draws_matrix objects loose chain information
  expect_equal(
    summarise_draws(draws_list, default_summary_measures()),
    summarise_draws(draws_list2, default_summary_measures())
  )

  draws_array <- as_draws_array(draws_list)
  draws_list2 <- as_draws_list(draws_array)
  expect_equal(draws_list, draws_list2)

  draws_df <- as_draws_df(draws_list)
  draws_list2 <- as_draws_list(draws_df)
  expect_equal(draws_list, draws_list2)
})

test_that("matrices can be transformed to draws_matrix objects", {
  x <- round(rnorm(200), 2)
  x <- array(x, dim = c(40, 5))
  dimnames(x) <- list(NULL, paste0("theta", 1:5))

  y <- as_draws(x)
  expect_is(y, "draws_matrix")
  expect_equal(variables(y), colnames(x))
  expect_equal(niterations(y), 40)
  expect_equal(nchains(y), 1)
})

test_that("arrays can be transformed to draws_array objects", {
  x <- round(rnorm(200), 2)
  x <- array(x, dim = c(10, 4, 5))
  dimnames(x) <- list(NULL, NULL, paste0("theta", 1:5))

  y <- as_draws(x)
  expect_is(y, "draws_array")
  expect_equal(variables(y), dimnames(x)[[3]])
  expect_equal(niterations(y), 10)
  expect_equal(nchains(y), 4)
})

test_that("data.frames can be transformed to draws_df objects", {
  x <- data.frame(
    v1 = rnorm(100),
    v2 = rnorm(100)
  )
  y <- as_draws(x)
  expect_is(y, "draws_df")
  expect_equal(variables(y), names(x))
  expect_equal(niterations(y), 100)
  expect_equal(nchains(y), 1)

  # are .iteration and .chain automatically used?
  x2 <- x
  x2$.iteration <- 1:100
  x2$.chain <- rep(1:4, each = 25)
  y2 <- as_draws(x2)
  expect_is(y2, "draws_df")
  expect_equal(variables(y2), names(x))
  expect_equal(niterations(y2), 25)
  expect_equal(nchains(y2), 4)
})

test_that("lists can be transformed to draws_list objects", {
  x <- list(
    list(
      v1 = rnorm(50),
      v2 = rnorm(50)
    ),
    list(
      v1 = rnorm(50),
      v2 = rnorm(50)
    )
  )
  y <- as_draws(x)
  expect_is(y, "draws_list")
  expect_equal(variables(y), names(x[[1]]))
  expect_equal(ndraws(y), 100)
  expect_equal(nchains(y), 2)
})
