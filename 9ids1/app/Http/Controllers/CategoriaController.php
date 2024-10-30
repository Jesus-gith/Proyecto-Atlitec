<?php
namespace App\Http\Controllers;
use App\Models\Categoria;
use Illuminate\Http\Request;

class CategoriaController extends Controller
{
    public function index(Request $req)
    {
        if ($req->id) {
            $categoria = Categoria::find($req->id);
        } else {
            $categoria = new Categoria();
        }
        return view('categoria');
    }
    public function list()
    {
        $categorias = Categoria::all();
        return view('categorias', compact('categorias'));
    }
    public function getAPI(Request $req){
        $categoria = Categoria::find($req->id);
        return $categoria;
    }
    public function listAPI()
    {
        $categorias = Categoria::all();
        return $categorias;
    }
    public function saveAPI(Request $req){
        if($req->id !=0){
            $categoria = Categoria::find($req->id);
        }
        else{
            $categoria = new Categoria();
        }
        $categoria -> nombre = $req->nombre;
        $categoria -> id_usuario = $req->id_usuario;
        $categoria->save();  
        return "Ok";

    }
    public function deleteAPI(Request $req){
        $categoria = Categoria::find($req->id);
        $categoria->delete();
        return "Ok";

    }
}
