import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReporteNotificadoView extends StatefulWidget {
  const ReporteNotificadoView({
    Key? key,
    this.mainScreenAnimationController,
    this.mainScreenAnimation,
  }) : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _ReporteNotificadoViewState createState() => _ReporteNotificadoViewState();
}

class _ReporteNotificadoViewState extends State<ReporteNotificadoView>
    with TickerProviderStateMixin {
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: SizedBox(
                    height: 1000, // Altura fija
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('scans')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              }
                              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                return Center(child: Text("No hay registros"));
                              }

                              var scans = snapshot.data!.docs;

                              return ListView.builder(
                                itemCount: scans.length,
                                itemBuilder: (context, index) {
                                  var data = scans[index].data() as Map<String, dynamic>;

                                  return Container(
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.green, width: 2), // ✅ Borde verde
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26, // ✅ Sombra
                                          blurRadius: 6,
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(10),
                                      leading: data["imageUrl"] != null
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: Image.network(
                                                data["imageUrl"],
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Icon(Icons.image, size: 50, color: Colors.green),
                                      title: Text(
                                        "Residuo: ${data["tipoResiduo"] ?? "Desconocido"}",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Categoría: ${data["categoria"] ?? "N/A"}"),
                                          Text("Recomendación: ${data["recomendacion"] ?? "N/A"}"),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
