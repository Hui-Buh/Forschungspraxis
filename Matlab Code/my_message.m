function my_message(text, clean)
    global Listbox
    if clean == 0
        set(Listbox, 'String', [{text}; get(Listbox, 'String')]);
        drawnow
    elseif clean == 1
        set(Listbox, 'String', text);
        drawnow
    elseif clean == 2
        list_text = get(Listbox, 'String');
        list_text{1} = text;
        set(Listbox, 'String', list_text);
        drawnow
    end
end