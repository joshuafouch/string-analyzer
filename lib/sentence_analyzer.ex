defmodule SentenceAnalyzer do
  use Application

  # my input
  @input "The unanimous Declaration of the thirteen united States of America, When in the Course of human events, it becomes necessary for one people to dissolve the political bands which have connected them with another, and to assume among the powers of the earth, the separate and equal station to which the Laws of Nature and of Nature's God entitle them, a decent respect to the opinions of mankind requires that they should declare the causes which impel them to the separation.
We hold these truths to be self-evident, that all men are created equal, that they are endowed by their Creator with certain unalienable Rights, that among these are Life, Liberty and the pursuit of Happiness. That to secure these rights, Governments are instituted among Men, deriving their self-evident just powers from the consent of the governed, That whenever any Form of Government becomes destructive of these ends, it is the Right of the People to alter or to abolish it, and to institute new Government, laying its foundation on such principles and organizing its powers in such form, as to them shall seem most likely to effect their Safety and Happiness. Prudence, indeed, will dictate that Governments long established should not be changed for light and transient causes; and accordingly all experience hath shewn, that mankind are more disposed to suffer, while evils are sufferable, than to right themselves by abolishing the forms to which they are accustomed. But when a long train of abuses and usurpations, pursuing invariably the same Object evinces a design to reduce them under absolute Despotism, it is their right, it is their duty, to throw off such Government, and to provide new Guards for their future security. Such has been the patient sufferance of these Colonies; and such is now the necessity which constrains them to alter their former Systems of Government. The history of the present King of Great Britain is a history of repeated injuries and usurpations, all having in direct object the establishment of an absolute Tyranny over these States. To prove this, let Facts be submitted to a candid world."
  #@input "Flappy Bird is my favorite, game. How about your favorite game?"

  # for starting the program
  def start(_type, _args) do

    analyze(@input)
    Supervisor.start_link([], strategy: :one_for_one)

  end

  # for reading it the input and outputting results of functions
  def analyze(input) do

    # word count
    word_count = wc(input)

    # sentence count
    sentence_count = sc(input)

    # repeated words histogram
    repeated_count = rc(input)


    # output
    IO.puts("Word Count: #{word_count}")
    IO.puts("Sentence Count: #{sentence_count}")
    IO.inspect(repeated_count, label: "Repeated Words")
      # inspect is used for outputting data structures
      # IO.puts() doesnt work for some reason

  end


  # function outputs list of words, uncapitalized, and no other symbols
  def word_list(input) do

    # split function with regex delimiter, pipe into length()
    # uncapitalize everything for frequency count
    input
    |> String.split(~r/[\s]+/, trim: true)
    |> Enum.map(&String.downcase/1) # map HOF!
    |> Enum.map(&delete_symbols/1)

  end

  # delete unwanted symbols for word list
  def delete_symbols(word) do

    word
    |> String.replace(~r/[!?.;:""@#$%&*,]/, "")

  end

  #function outputs list of sentences
  def sent_list(input) do

    # split functino with regex delimiter
    input
    |> String.split(~r/[!?.](\s+|$)/, trim: true)
    |> Enum.map(&String.downcase/1)

  end

  # word count
  def wc(input) do

    input
    |> word_list()
    |> length()

  end

  # sentence count
  def sc(input) do

    input
    |> sent_list()
    |> length()

  end


  # repeated words count
  def rc(words) do

    # call recursive function
    word_list(words)
    |> freqy(%{})
    |> filter_repeated()
    |> Enum.into(%{})

  end

  # base case if nothing left in word list
  def freqy([], freqmap) do
    freqmap
  end

  # map for repeated word frequency
  def freqy([head | rest], freqmap) do

    # if exist, incremment counter, if not exist, add the map
    freqymap = Map.update(freqmap, head, 1, &(&1 + 1))

    # Map.update(map, key, default, function)
    # &() is an anonymous function
    # &1 is the given input (the accumulator value for given word)

    # recursive call
    freqy(rest, freqymap)

  end


  # filters out words that aren't repeated
  def filter_repeated(map) do

    map
    |> Enum.filter(fn {_, acc} -> acc > 1 end)  # HOF filter!

    # Enum.filter(map, fn element -> condition end)

  end
end
