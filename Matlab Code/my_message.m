function my_message(text, clean)
    global Listbox
    if clean == 0
        set(Listbox, 'String', [{text}; get(Listbox, 'String')]);
        drawnow
    else
        set(Listbox, 'String', text);
        drawnow
    end
end